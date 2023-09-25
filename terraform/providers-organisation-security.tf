###################################
# organisation-security providers #
###################################

# us-east-1
provider "aws" {
  region = "us-east-1"
  alias  = "organisation-security-us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# us-east-2
provider "aws" {
  region = "us-east-2"
  alias  = "organisation-security-us-east-2"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# us-west-1
provider "aws" {
  region = "us-west-1"
  alias  = "organisation-security-us-west-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# us-west-2
provider "aws" {
  region = "us-west-2"
  alias  = "organisation-security-us-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# ap-south-1
provider "aws" {
  region = "ap-south-1"
  alias  = "organisation-security-ap-south-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# ap-northeast-3
provider "aws" {
  region = "ap-northeast-3"
  alias  = "organisation-security-ap-northeast-3"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# ap-northeast-2
provider "aws" {
  region = "ap-northeast-2"
  alias  = "organisation-security-ap-northeast-2"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# ap-southeast-1
provider "aws" {
  region = "ap-southeast-1"
  alias  = "organisation-security-ap-southeast-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# ap-southeast-2
provider "aws" {
  region = "ap-southeast-2"
  alias  = "organisation-security-ap-southeast-2"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# ap-northeast-1
provider "aws" {
  region = "ap-northeast-1"
  alias  = "organisation-security-ap-northeast-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# ca-central-1
provider "aws" {
  region = "ca-central-1"
  alias  = "organisation-security-ca-central-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# eu-central-1
provider "aws" {
  region = "eu-central-1"
  alias  = "organisation-security-eu-central-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# eu-west-1
provider "aws" {
  region = "eu-west-1"
  alias  = "organisation-security-eu-west-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# eu-west-2
provider "aws" {
  region = "eu-west-2"
  alias  = "organisation-security-eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# eu-west-3
provider "aws" {
  region = "eu-west-3"
  alias  = "organisation-security-eu-west-3"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# eu-north-1
provider "aws" {
  region = "eu-north-1"
  alias  = "organisation-security-eu-north-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}

# sa-east-1
provider "aws" {
  region = "sa-east-1"
  alias  = "organisation-security-sa-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${local.organisation_security_id}:role/OrganizationAccountAccessRole"
  }
}
