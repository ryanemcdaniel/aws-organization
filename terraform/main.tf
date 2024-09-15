terraform {
  required_version = "1.9.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
  backend "s3" {
    region               = "us-east-1"
    bucket               = "tf-ryanemcdaniel-management"
    workspace_key_prefix = ""
    key                  = "aws-organization.tfstate"
    dynamodb_table       = "tf-ryanemcdaniel-management-lock"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      comp = "org"
      env  = "org"
      git  = "git@github.com:ryanemcdaniel/aws-organization.git"
    }
  }
}

output "account_ids" {
  value = {
    acc_root = {
      management = aws_organizations_organization.organization.master_account_id
      human      = aws_organizations_account.human.id
      infra      = aws_organizations_account.infra.id
    }
    dffp = {
      qual = aws_organizations_account.dffp_qual.id
      prod = aws_organizations_account.dffp_prod.id
    }
    ryan = {
      qual = aws_organizations_account.ryan_qual.id
      prod = aws_organizations_account.ryan_prod.id
    }
  }
}