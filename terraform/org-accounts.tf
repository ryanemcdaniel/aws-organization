data "aws_ssm_parameter" "management" { name = "/ACCOUNT/EMAIL/ROOT/MANAGEMENT" }
data "aws_ssm_parameter" "human" { name = "/ACCOUNT/EMAIL/ROOT/HUMAN" }
data "aws_ssm_parameter" "infra" { name = "/ACCOUNT/EMAIL/ROOT/INFRA" }
data "aws_ssm_parameter" "dffp_prod" { name = "/ACCOUNT/EMAIL/DFFP/PROD" }
data "aws_ssm_parameter" "dffp_qual" { name = "/ACCOUNT/EMAIL/DFFP/QUAL" }
data "aws_ssm_parameter" "ryan_qual" { name = "/ACCOUNT/EMAIL/RYAN/QUAL" }
data "aws_ssm_parameter" "ryan_prod" { name = "/ACCOUNT/EMAIL/RYAN/PROD" }

# ==
# ROOT
# ==
resource "aws_organizations_account" "management" {
  parent_id = local.org_root_id
  name      = "ryanemcdaniel"
  email     = data.aws_ssm_parameter.management.value
}

resource "aws_organizations_account" "human" {
  parent_id = local.org_root_id
  name      = "human"
  email     = data.aws_ssm_parameter.human.value
}

resource "aws_organizations_account" "infra" {
  parent_id = local.org_root_id
  name      = "infra"
  email     = data.aws_ssm_parameter.infra.value
}

# ==
# DFFP
# ==
resource "aws_organizations_organizational_unit" "dffp" {
  name      = "dffp"
  parent_id = local.org_root_id
}

resource "aws_organizations_account" "dffp_qual" {
  parent_id = aws_organizations_organizational_unit.dffp.id
  name      = "dffp-qual"
  email     = data.aws_ssm_parameter.dffp_qual.value
}

resource "aws_organizations_account" "dffp_prod" {
  parent_id = aws_organizations_organizational_unit.dffp.id
  name      = "dffp-prod"
  email     = data.aws_ssm_parameter.dffp_prod.value
}

# ==
# RYAN
# ==
resource "aws_organizations_organizational_unit" "ryan" {
  name      = "ryan"
  parent_id = local.org_root_id
}

resource "aws_organizations_account" "ryan_qual" {
  parent_id = aws_organizations_organizational_unit.ryan.id
  name      = "ryan-qual"
  email     = data.aws_ssm_parameter.ryan_qual.value
}

resource "aws_organizations_account" "ryan_prod" {
  parent_id = aws_organizations_organizational_unit.ryan.id
  name      = "ryan-prod"
  email     = data.aws_ssm_parameter.ryan_prod.value
}