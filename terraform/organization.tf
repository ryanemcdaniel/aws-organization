# ==
# AWS Organization
# ==
resource "aws_organizations_organization" "organization" {
  aws_service_access_principals = [
    "account.amazonaws.com",                 # RegisterDelegatedAdministrator
    "billing-cost-management.amazonaws.com", # AWSServiceRoleForSplitCostAllocationData
    "cloudtrail.amazonaws.com",              # AWSServiceRoleForCloudTrail
    "health.amazonaws.com",                  # AWSServiceRoleForHealth_Organizations
    "ram.amazonaws.com",                     # AWSServiceRoleForResourceAccessManager
    "resource-explorer-2.amazonaws.com",     # AWSServiceRoleForResourceExplorer
    "servicequotas.amazonaws.com",           # AWSServiceRoleForServiceQuotas
    "sso.amazonaws.com",                     # AWSServiceRoleForSSO
    # "ssm.amazonaws.com",                      # AWSServiceRoleForAmazonSSM_AccountDiscovery
    # "tagpolicies.tag.amazonaws.com",          # no role
    "reporting.trustedadvisor.amazonaws.com", # AWSServiceRoleForTrustedAdvisorReporting
  ]
  enabled_policy_types = [
    "AISERVICES_OPT_OUT_POLICY",
    "SERVICE_CONTROL_POLICY"
  ]
  feature_set = "ALL"
}

data "aws_ssoadmin_instances" "sso" {}

locals {
  org_root_id               = aws_organizations_organization.organization.roots[0].id
  org_management_account_id = aws_organizations_organization.organization.master_account_id

  sso_identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]
  sso_instance_arn      = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
}

# ==
# DFFP
# ==
resource "aws_organizations_organizational_unit" "dffp" {
  name      = "dffp"
  parent_id = local.org_root_id
}

# ==
# RYAN
# ==
resource "aws_organizations_organizational_unit" "ryan" {
  name      = "ryan"
  parent_id = local.org_root_id
}



# ==
# Organization Accounts
# ==
resource "aws_organizations_account" "account" {
  for_each  = var.accounts
  parent_id = local.org_root_id
  email     = each.value.email
  name      = each.value.name
}

# ==
# legacy
# ==
data "aws_ssm_parameter" "ryan_qual" {name = "/ACCOUNT/EMAIL/RYAN/QUAL"}

resource "aws_organizations_account" "ryan_qual" {
  parent_id = local.org_root_id
  name      = "ryan-qual"
  email     = data.aws_ssm_parameter.ryan_qual.value
}

# ==
# temp
# ==
moved {
  from = aws_organizations_account.management
  to   = aws_organizations_account.account["management"]
}
moved {
  from = aws_organizations_account.human
  to   = aws_organizations_account.account["human"]
}
moved {
  from = aws_organizations_account.infra
  to   = aws_organizations_account.account["infra"]
}


moved {
  from = aws_organizations_account.dffp_prod
  to   = aws_organizations_account.account["prod"]
}
moved {
  from = aws_organizations_account.dffp_qual
  to   = aws_organizations_account.account["qual"]
}
moved {
  from = aws_organizations_account.ryan_prod
  to   = aws_organizations_account.account["dev"]
}