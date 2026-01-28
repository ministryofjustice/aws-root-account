################
# Tag policies #
################

# See https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_tag-policies.html for more information
# Note: These don't enforce the usage of tags, and will only report if a resource is tagged using the specified keys
# (i.e. non-tagged resources aren't shown as non-compliant)

##################
# Mandatory tags #
##################
resource "aws_organizations_policy" "mandatory_tags" {
  name        = "mandatory-tags"
  description = "A tag policy for mandatory tags as listed in the MoJ Technical Guidance."
  type        = "TAG_POLICY"
  tags        = {}

  content = <<CONTENT
{
  "tags": {
    "business-unit": {
      "tag_key": {
        "@@assign": "business-unit"
      },
      "tag_value": {
        "@@assign": [
          "HMPPS",
          "OPG",
          "LAA",
          "Central Digital",
          "Technology Services",
          "HMCTS",
          "CICA",
          "OCTO"
        ]
      }
    },
    "service-area": {
      "tag_key": {
        "@@assign": "service-area"
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

# Attach policy to root (i.e. target all AWS accounts in the organisation)
resource "aws_organizations_policy_attachment" "mandatory_tags" {
  policy_id = aws_organizations_policy.mandatory_tags.id
  target_id = aws_organizations_organization.default.roots[0].id
}

##################
# Mandatory tags - alerting activated #
##################
resource "aws_organizations_policy" "mandatory_tags_with_alerting" {
  name        = "mandatory-tags-with-alerting"
  description = "A tag policy for mandatory tags as listed in the MoJ Technical Guidance with alerting enabled."
  type        = "TAG_POLICY"
  tags        = {}

  content = <<CONTENT
{
  "tags": {
    "business-unit": {
      "tag_key": {
        "@@assign": "business-unit"
      },
      "tag_value": {
        "@@assign": [
          "HMPPS",
          "OPG",
          "LAA",
          "Central Digital",
          "Technology Services",
          "HMCTS",
          "CICA",
          "OCTO"
        ]
      },
      "report_required_tag_for": { "@@assign": ["*"] }
    },
    "service-area": {
      "tag_key": {
        "@@assign": "service-area"
      },
      "report_required_tag_for": { "@@assign": ["*"] }
    },
    "application": {
      "tag_key": {
        "@@assign": "application"
      },
      "report_required_tag_for": { "@@assign": ["*"] }
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
      },
      "report_required_tag_for": { "@@assign": ["*"] }
    },
    "owner": {
      "tag_key": {
        "@@assign": "owner"
      },
      "report_required_tag_for": { "@@assign": ["*"] }
    }
  }
}
CONTENT
}

# Attach policy to coat-development account
resource "aws_organizations_policy_attachment" "mandatory_tags_with_alerting" {
  policy_id = aws_organizations_policy.mandatory_tags_with_alerting.id
  target_id = data.aws_organizations_organizational_units.platforms_and_architecture_modernisation_platform_children["Modernisation Platform Member"]["modernisation-platform-coat"]["coat-development"].id
}

#################
# Optional tags #
#################
resource "aws_organizations_policy" "optional_tags" {
  name        = "optional-tags"
  description = "A tag policy for optional tags as listed in the MoJ Technical Guidance."
  type        = "TAG_POLICY"
  tags        = {}

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

# Attach policy to root (i.e. target all AWS accounts in the organisation)
resource "aws_organizations_policy_attachment" "optional_tags" {
  policy_id = aws_organizations_policy.optional_tags.id
  target_id = aws_organizations_organization.default.roots[0].id
}
