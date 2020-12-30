# AWS Organizations: Tag policies
# See: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html
# Note that these don't enforce the usage of tags, and will only report if a resource is tagged using the specified keys.
# i.e. non-tagged resources aren't shown as non-compliant

# These tagging policies are from the MoJ Technical Guidance
# See: https://ministryofjustice.github.io/technical-guidance/documentation/standards/documenting-infrastructure-owners.html#tags-you-should-use

## Mandatory tags
resource "aws_organizations_policy" "mandatory-tags" {
  name = "mandatory-tags"
  description = "A tag policy for mandatory tags as listed in the MoJ Technical Guidance."
  type = "TAG_POLICY"

  content = <<CONTENT
{
  "tags": {
    "business-unit": {
      "tag_key": {
        "@@assign": "business-unit"
      },
      "tag_value": {
        "@@assign": [
          "HQ",
          "HMPPS",
          "OPG",
          "LAA",
          "HMCTS",
          "CICA",
          "Platforms"
        ]
      }
    },
    "application": {
      "tag_key": {
        "@@assign": "application"
      }
    },
    "is-production": {
      "tag_key": {
        "@@assign": "is-production"
      },
      "tag_value": {
        "@@assign": [
          "true",
          "false"
        ]
      }
    },
    "owner": {
      "tag_key": {
        "@@assign": "owner"
      }
    }
  }
}
CONTENT
}

## Optional tags
resource "aws_organizations_policy" "optional-tags" {
  name = "optional-tags"
  description = "A tag policy for optional tags as listed in the MoJ Technical Guidance."
  type = "TAG_POLICY"

  content = <<CONTENT
{
  "tags": {
    "environment-name": {
      "tag_key": {
        "@@assign": "environment-name"
      }
    },
    "component": {
      "tag_key": {
        "@@assign": "component"
      }
    },
    "infrastructure-support": {
      "tag_key": {
        "@@assign": "infrastructure-support"
      }
    },
    "runbook": {
      "tag_key": {
        "@@assign": "runbook"
      }
    },
    "source-code": {
      "tag_key": {
        "@@assign": "source-code"
      }
    }
  }
}
CONTENT
}

# We can test the tag policies on the Modernisation Platform account
# Note that when you attach a tag policy, it can take 48 hours to evaluate compliance.
resource "aws_organizations_policy_attachment" "modernisation-platform-mandatory-tags-policy" {
  policy_id = aws_organizations_policy.mandatory-tags.id
  target_id = aws_organizations_account.modernisation-platform.id
}

resource "aws_organizations_policy_attachment" "modernisation-platform-optional-tags-policy" {
  policy_id = aws_organizations_policy.optional-tags.id
  target_id = aws_organizations_account.modernisation-platform.id
}
