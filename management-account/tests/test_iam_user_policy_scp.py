"""Offline checks of the rendered IAM-54 pilot, not an AWS policy simulator.

Run: python3 -m unittest discover -s management-account/tests
Requires Terraform; creates no AWS resources and reads no credentials/state.
"""
import fnmatch
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'terraform/organizations-policy-iam-user-policies-pilot.tf'
ACCOUNT = '111122223333'


class PilotPolicyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Render the actual production locals with only synthetic account input.
        # Exclude resource blocks so Terraform cannot contact AWS or read state.
        source = SOURCE.read_text().split('resource "aws_organizations_policy"', 1)[0]
        with tempfile.TemporaryDirectory(prefix='iam54-offline-') as directory:
            Path(directory, 'main.tf').write_text(source + '\nlocals {\n accounts = { active_only = { "sprinkler-development" = "' + ACCOUNT + '" } }\n}\n')
            result = subprocess.run(
                ['terraform', 'console', '-no-color'], cwd=directory,
                input='jsonencode(local.iam_user_policy_pilot_document)\n',
                text=True, capture_output=True, check=True,
            )
            cls.policy = json.loads(json.loads(result.stdout))

    def denied(self, action, role='Developer', user='service-user', account=ACCOUNT):
        """Evaluate only the exact Deny/Action/Resource/ArnNotEquals subset used here."""
        principal = f'arn:aws:iam::{account}:role/{role}'
        target = f'arn:aws:iam::{ACCOUNT}:user/{user}'
        for statement in self.policy['Statement']:
            if action != statement['Action']:
                continue
            if not fnmatch.fnmatchcase(target, statement['Resource']):
                continue
            exceptions = statement['Condition']['ArnNotEquals']['aws:PrincipalArn']
            if principal not in exceptions:
                return True
        return False

    def test_only_two_exact_user_policy_writes_are_denied(self):
        statements = self.policy['Statement']
        self.assertEqual(self.policy['Version'], '2012-10-17')
        self.assertEqual(len(statements), 2)
        self.assertEqual({s['Action'] for s in statements}, {'iam:PutUserPolicy', 'iam:AttachUserPolicy'})
        for statement in statements:
            self.assertEqual(statement['Effect'], 'Deny')
            self.assertEqual(statement['Resource'], f'arn:aws:iam::{ACCOUNT}:user/*')
        self.assertLess(len(json.dumps(self.policy, separators=(',', ':'))), 5120)

    def test_nonexempt_callers_and_user_paths_are_denied(self):
        for role in ['Developer', 'AWSReservedSSO_AdministratorAccess_example', 'github-actions-plan', 'github-actions-development-cluster']:
            for action in ['iam:PutUserPolicy', 'iam:AttachUserPolicy']:
                for user in ['email_user', 'service/supplier']:
                    with self.subTest(role=role, action=action, user=user):
                        self.assertTrue(self.denied(action, role, user))

    def test_approved_provisioning_and_administration_are_exempt(self):
        for role in ['ModernisationPlatformAccess', 'MemberInfrastructureAccess', 'github-actions', 'github-actions-apply']:
            for action in ['iam:PutUserPolicy', 'iam:AttachUserPolicy']:
                self.assertFalse(self.denied(action, role))
                # Matching role names in a different account are not exceptions.
                self.assertTrue(self.denied(action, role, account='444455556666'))

    def test_quarantine_can_only_bypass_inline_restriction(self):
        self.assertFalse(self.denied('iam:PutUserPolicy', 'credential-responder-lambda'))
        self.assertTrue(self.denied('iam:AttachUserPolicy', 'credential-responder-lambda'))
        self.assertTrue(self.denied('iam:PutUserPolicy', 'credential-responder-lambda-other'))

    def test_group_role_and_cleanup_operations_are_not_restricted(self):
        for action in ['iam:PutGroupPolicy', 'iam:AttachGroupPolicy', 'iam:PutRolePolicy', 'iam:AttachRolePolicy', 'iam:DeleteUserPolicy', 'iam:DetachUserPolicy']:
            self.assertFalse(self.denied(action))

    def test_pilot_attachment_is_single_account_and_policy_is_monitored(self):
        source = SOURCE.read_text()
        attachment = source.split('resource "aws_organizations_policy_attachment" "iam_user_policy_pilot"', 1)[1]
        self.assertIn('target_id = local.iam_user_policy_pilot_account_id', attachment)
        self.assertNotIn('for_each', attachment)
        self.assertNotIn('organizational_unit', attachment)
        alerting = (ROOT / 'terraform/alerting-modernisation-platform-scp.tf').read_text()
        self.assertIn('aws_organizations_policy.iam_user_policy_pilot.id,', alerting)


if __name__ == '__main__':
    unittest.main()
