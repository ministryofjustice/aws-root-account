"""Copy CloudWatch Logs subscription batches to S3 without logging their contents."""

import gzip
import hashlib
import json
import os
from datetime import datetime, timezone

import boto3
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.data_classes import CloudWatchLogsEvent, event_source
from aws_lambda_powertools.utilities.typing import LambdaContext
from botocore.config import Config
from botocore.exceptions import ClientError

logger = Logger(service="scim-log-forwarder")
s3 = boto3.client(
    "s3",
    config=Config(
        connect_timeout=2,
        read_timeout=5,
        retries={"mode": "standard", "total_max_attempts": 3},
    ),
)
DESTINATION_BUCKET = os.environ["DESTINATION_BUCKET"]
DESTINATION_PREFIX = os.environ["DESTINATION_PREFIX"]
DESTINATION_KMS_KEY_ARN = os.environ["DESTINATION_KMS_KEY_ARN"]
SOURCE_LAMBDA_NAMES = json.loads(os.environ["SOURCE_LAMBDA_NAMES"])


@logger.inject_lambda_context(log_event=False, clear_state=True)
@event_source(data_class=CloudWatchLogsEvent)
def lambda_handler(event: CloudWatchLogsEvent, context: LambdaContext) -> None:
    logs = event.parse_logs_data()
    if logs.message_type == "CONTROL_MESSAGE":
        logger.info("Received CloudWatch Logs control message")
        return
    if logs.message_type != "DATA_MESSAGE":
        logger.error("Unsupported CloudWatch Logs message type")
        raise ValueError("Unsupported CloudWatch Logs message type")

    events = logs.log_events
    if not events:
        logger.info("Received an empty CloudWatch Logs batch")
        return

    try:
        source_name = SOURCE_LAMBDA_NAMES[logs.log_group]
    except KeyError as error:
        raise ValueError(f"Unexpected CloudWatch log group: {logs.log_group}") from error

    body = "".join(
        json.dumps(
            {
                "owner": logs.owner,
                "logGroup": logs.log_group,
                "logStream": logs.log_stream,
                "id": log_event.get_id,
                "timestamp": log_event.timestamp,
                "message": log_event.message,
            },
            ensure_ascii=False,
            sort_keys=True,
            separators=(",", ":"),
        )
        + "\n"
        for log_event in events
    ).encode("utf-8")
    day = datetime.fromtimestamp(
        min(log_event.timestamp for log_event in events) / 1000, tz=timezone.utc
    )
    key = (
        f"{DESTINATION_PREFIX}{source_name}/AWSLogs/{logs.owner}/"
        f"{day:%Y/%m/%d}/{hashlib.sha256(body).hexdigest()}.json.gz"
    )

    try:
        s3.put_object(
            Bucket=DESTINATION_BUCKET,
            Key=key,
            Body=gzip.compress(body, mtime=0),
            ContentType="application/x-ndjson",
            ContentEncoding="gzip",
            ServerSideEncryption="aws:kms",
            SSEKMSKeyId=DESTINATION_KMS_KEY_ARN,
            IfNoneMatch="*",
        )
    except ClientError as error:
        if error.response["Error"]["Code"] == "PreconditionFailed":
            logger.info("Log batch already exists", object_key=key)
            return
        logger.exception("S3 log delivery failed", object_key=key)
        raise

    logger.info("Forwarded log batch", object_key=key, log_event_count=len(events))
