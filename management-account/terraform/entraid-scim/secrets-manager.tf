# Retrieving existing secret

data "aws_secretsmanager_secret" "azure_aws_connectivity_details" {
  name = "entra_id_aws_connectivity_details"
}

data "aws_secretsmanager_secret_version" "azure_aws_connectivity_details" {
  secret_id = data.aws_secretsmanager_secret.azure_aws_connectivity_details.id
}
