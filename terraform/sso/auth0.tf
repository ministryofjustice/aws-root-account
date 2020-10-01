data "aws_iam_account_alias" "current" {}
data "aws_caller_identity" "current" {}

# Auth0: Client setup
resource "auth0_client" "saml" {
  name        = "AWS-SAML: ${data.aws_iam_account_alias.current.account_alias}"
  description = "SAML provider for the ${data.aws_iam_account_alias.current.account_alias} account"
  callbacks   = ["https://signin.aws.amazon.com/saml"]
  logo_uri    = "https://ministryofjustice.github.io/assets/moj-crest.png"
  app_type    = "regular_web"

  addons {
    samlp {
      audience = "https://signin.aws.amazon.com/saml"

      mappings = {
        email = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
        name  = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
      }

      create_upn_claim                   = false
      passthrough_claims_with_no_mapping = false
      map_unknown_claims_as_is           = false
      map_identities                     = false
      name_identifier_format             = "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"

      name_identifier_probes = [
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier",
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
      ]

    }
  }
}

# # Auth0: Connection setup
resource "auth0_connection" "github_saml_connection" {
  name            = "GitHub"
  strategy        = "github"
  enabled_clients = [auth0_client.saml.id]
  options {
    client_id     = var.auth0_github_client_id
    client_secret = var.auth0_github_client_secret
    # Scope definitions aren't supported, but these are the ones you need in Auth0
    scopes = ["read:user", "read:org"]
  }
}

# Auth0 Rules: Set the configuration variables,
# which are accessible in Auth0 rules
resource "auth0_rule_config" "aws_account_id" {
  key   = "AWS_ACCOUNT_ID"
  value = data.aws_caller_identity.current.account_id
}

resource "auth0_rule_config" "aws_saml_provider_name" {
  key   = "AWS_SAML_PROVIDER_NAME"
  value = aws_iam_saml_provider.auth0.name
}

resource "auth0_rule_config" "aws_role_name" {
  key   = "AWS_ROLE_NAME"
  value = aws_iam_role.federated_role.name
}

resource "auth0_rule_config" "github_allowed_organisations" {
  key   = "ALLOWED_ORGANISATIONS"
  value = jsonencode(var.auth0_github_allowed_orgs)
}

# Auth0 Rules: Attach rules from this repository
resource "auth0_rule" "allow_github_organisations" {
  name    = "Allow specific GitHub Organisations"
  script  = file("${path.module}/auth0_rules/allow-github-organisations.js")
  enabled = true
  order   = 10
}

resource "auth0_rule" "map_teams_to_roles" {
  name    = "Map teams to roles"
  script  = file("${path.module}/auth0_rules/map-teams-to-roles.js")
  enabled = true
  order   = 20
}