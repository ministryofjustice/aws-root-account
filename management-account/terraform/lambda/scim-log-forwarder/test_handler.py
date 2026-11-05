"""Unit tests using the real Powertools decoder and stubbed S3 API."""

import base64
import copy
import gzip
import hashlib
import json
import os
import unittest
import zlib
from types import SimpleNamespace
from unittest.mock import patch

from botocore.exceptions import ClientError
from botocore.stub import ANY, Stubber

with patch.dict(
    os.environ,
    {
        "AWS_ACCESS_KEY_ID": "testing",
        "AWS_SECRET_ACCESS_KEY": "testing",
        "AWS_DEFAULT_REGION": "eu-west-2",
        "AWS_EC2_METADATA_DISABLED": "true",
        "DESTINATION_BUCKET": "test-cloudtrail-bucket",
        "DESTINATION_PREFIX": "AWSLogs/123456789012/SCIM/",
        "DESTINATION_KMS_KEY_ARN": "arn:aws:kms:eu-west-2:123456789012:key/test-key",
    },
):
    import handler


class ForwarderTests(unittest.TestCase):
    def setUp(self):
        self.payload = {
            "messageType": "DATA_MESSAGE",
            "owner": "123456789012",
            "logGroup": "/aws/lambda/aws-sso-scim-github",
            "logStream": "2026/01/01/[$LATEST]test",
            "subscriptionFilters": ["scim-to-s3"],
            "logEvents": [
                {
                    "id": "event-1",
                    "timestamp": 1767225600000,
                    "message": "creating user example@example.invalid",
                },
                {
                    "id": "event-2",
                    "timestamp": 1767225601000,
                    "message": 'multiple\nlines with "quotes" and \u00e9',
                },
            ],
        }
        self.context = SimpleNamespace(
            function_name="scim-log-forwarder",
            memory_limit_in_mb=128,
            invoked_function_arn="arn:aws:lambda:eu-west-2:123456789012:function:scim-log-forwarder",
            aws_request_id="request-1",
        )
        self.expected_params = {
            "Bucket": "test-cloudtrail-bucket",
            "Key": ANY,
            "Body": ANY,
            "ContentType": "application/x-ndjson",
            "ContentEncoding": "gzip",
            "ServerSideEncryption": "aws:kms",
            "SSEKMSKeyId": "arn:aws:kms:eu-west-2:123456789012:key/test-key",
            "IfNoneMatch": "*",
        }

    def invoke(self, payload=None, mtime=0):
        encoded = base64.b64encode(
            gzip.compress(json.dumps(payload or self.payload).encode(), mtime=mtime)
        ).decode()
        return handler.lambda_handler({"awslogs": {"data": encoded}}, self.context)

    def test_preserves_each_message_and_its_source_metadata(self):
        for log_group in (
            "/aws/lambda/aws-sso-scim-github",
            "/aws/lambda/entra-id-scim-lambda",
        ):
            with self.subTest(log_group=log_group):
                self.payload["logGroup"] = log_group
                with Stubber(handler.s3) as stub:
                    stub.add_response("put_object", {}, self.expected_params)
                    with patch.object(
                        handler.s3, "put_object", wraps=handler.s3.put_object
                    ) as put, self.assertLogs("scim-log-forwarder", level="INFO") as captured:
                        self.invoke()

                    params = put.call_args.kwargs
                    body = gzip.decompress(params["Body"])
                    records = [json.loads(line) for line in body.splitlines()]
                    self.assertEqual(
                        records,
                        [
                            {
                                **log_event,
                                "owner": self.payload["owner"],
                                "logGroup": log_group,
                                "logStream": self.payload["logStream"],
                            }
                            for log_event in self.payload["logEvents"]
                        ],
                    )
                    self.assertEqual(len(body.splitlines()), 2)
                    self.assertEqual(
                        params["Key"],
                        "AWSLogs/123456789012/SCIM/2026/01/01/"
                        + hashlib.sha256(body).hexdigest()
                        + ".json.gz",
                    )
                    self.assertNotIn("example@example.invalid", "\n".join(captured.output))
                    stub.assert_no_pending_responses()

    def test_retries_use_the_same_key_and_do_not_overwrite_existing_objects(self):
        with Stubber(handler.s3) as stub:
            stub.add_response("put_object", {}, self.expected_params)
            stub.add_client_error(
                "put_object",
                service_error_code="PreconditionFailed",
                http_status_code=412,
                expected_params=self.expected_params,
            )
            with patch.object(handler.s3, "put_object", wraps=handler.s3.put_object) as put:
                self.invoke(mtime=1)
                self.context.aws_request_id = "request-2"
                self.invoke(mtime=2)
            self.assertEqual(put.call_args_list[0].kwargs, put.call_args_list[1].kwargs)
            stub.assert_no_pending_responses()

    def test_different_sources_produce_different_keys(self):
        with Stubber(handler.s3) as stub:
            stub.add_response("put_object", {}, self.expected_params)
            stub.add_response("put_object", {}, self.expected_params)
            with patch.object(handler.s3, "put_object", wraps=handler.s3.put_object) as put:
                self.invoke()
                self.payload["logStream"] = "another-stream"
                self.invoke()
            self.assertNotEqual(
                put.call_args_list[0].kwargs["Key"], put.call_args_list[1].kwargs["Key"]
            )

    def test_uses_the_earliest_event_date_in_utc(self):
        self.payload["logEvents"][0]["timestamp"] = 1767312000000
        with Stubber(handler.s3) as stub:
            stub.add_response("put_object", {}, self.expected_params)
            with patch.object(handler.s3, "put_object", wraps=handler.s3.put_object) as put:
                self.invoke()
            self.assertIn("/2026/01/01/", put.call_args.kwargs["Key"])

    def test_control_and_empty_batches_do_not_write_objects(self):
        empty = copy.deepcopy(self.payload)
        empty["logEvents"] = []
        with Stubber(handler.s3):
            self.invoke({"messageType": "CONTROL_MESSAGE"})
            self.invoke(empty)

    def test_s3_failures_propagate_for_lambda_retry(self):
        for error_code, status in (
            ("AccessDenied", 403),
            ("InternalError", 500),
            ("ConditionalRequestConflict", 409),
        ):
            with self.subTest(error_code=error_code), Stubber(handler.s3) as stub:
                stub.add_client_error(
                    "put_object",
                    service_error_code=error_code,
                    http_status_code=status,
                    expected_params=self.expected_params,
                )
                with self.assertRaises(ClientError), self.assertLogs(
                    "scim-log-forwarder", level="ERROR"
                ) as captured:
                    self.invoke()
                self.assertNotIn("example@example.invalid", "\n".join(captured.output))
                stub.assert_no_pending_responses()

    def test_unknown_message_types_fail(self):
        with self.assertRaises(ValueError), Stubber(handler.s3):
            self.invoke({"messageType": "UNKNOWN"})

    def test_invalid_compressed_input_fails(self):
        event = {"awslogs": {"data": base64.b64encode(b"not gzip").decode()}}
        with self.assertRaises(zlib.error), Stubber(handler.s3):
            handler.lambda_handler(event, self.context)

    def test_missing_required_log_fields_fail(self):
        for field in ("id", "timestamp", "message"):
            payload = copy.deepcopy(self.payload)
            del payload["logEvents"][0][field]
            with self.subTest(field=field), self.assertRaises(KeyError), Stubber(handler.s3):
                self.invoke(payload)


if __name__ == "__main__":
    unittest.main()
