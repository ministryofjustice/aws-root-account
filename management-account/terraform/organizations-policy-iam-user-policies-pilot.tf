# IAM-54: pilot prevention of direct IAM user policies in Sprinkler only.
# Keep account IDs explicit: a name-only exception across all accounts is broader
# than required. These role exceptions include approved MP administration, not
# just unattended automation. They do not grant permissions.
locals {
  iam_user_policy_pilot_account_id = local.accounts.active_only["sprinkler-development"]

  iam_user_policy_pilot_provisioning_role_arns = [
    for role in [
      "ModernisationPlatformAccess",
      "MemberInfrastructureAccess",
      "github-actions",
      "github-actions-apply"
    ] : "arn:aws:iam::${local.iam_user_policy_pilot_account_id}:role/${role}"
  ]

  # Separate statements keep quarantine's exception limited to inline writes.
  # There is no IAM condition key to restrict PutUserPolicy to a policy name
  # or to inspect its document: protect the responder role and its Lambda code.
  iam_user_policy_pilot_document = {
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyUnapprovedInlineUserPolicies"
        Effect   = "Deny"
        Action   = "iam:PutUserPolicy"
        Resource = "arn:aws:iam::${local.iam_user_policy_pilot_account_id}:user/*"
        Condition = {
          ArnNotEquals = {
            "aws:PrincipalArn" = concat(local.iam_user_policy_pilot_provisioning_role_arns, [
              "arn:aws:iam::${local.iam_user_policy_pilot_account_id}:role/credential-responder-lambda"
            ])
          }
        }
      },
      {
        Sid      = "DenyUnapprovedManagedUserPolicyAttachments"
        Effect   = "Deny"
        Action   = "iam:AttachUserPolicy"
        Resource = "arn:aws:iam::${local.iam_user_policy_pilot_account_id}:user/*"
        Condition = {
          ArnNotEquals = {
            "aws:PrincipalArn" = local.iam_user_policy_pilot_provisioning_role_arns
          }
        }
      }
    ]
  }
}

resource "aws_organizations_policy" "iam_user_policy_pilot" {
  name        = "Modernisation Platform IAM User Policies Pilot"
  description = "IAM-54: restrict direct IAM user policy writes in sprinkler-development, with approved provisioning and quarantine exceptions."
  type        = "SERVICE_CONTROL_POLICY"
  content     = jsonencode(local.iam_user_policy_pilot_document)

  tags = {
    business-unit = "Platforms"
    component     = "SERVICE_CONTROL_POLICY"
    source-code   = "${local.github_repository}/terraform/organizations-policy-iam-user-policies-pilot.tf"
  }
}

# Direct account attachment deliberately avoids affecting sibling/parent OUs.
# Check live attachment capacity before apply. Promote only after pilot evidence;
# do not attach this pilot to the parent Modernisation Platform OU.
resource "aws_organizations_policy_attachment" "iam_user_policy_pilot" {
  policy_id = aws_organizations_policy.iam_user_policy_pilot.id
  target_id = local.iam_user_policy_pilot_account_id
}
