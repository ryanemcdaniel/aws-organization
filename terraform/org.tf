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

locals {
  org_root_id               = aws_organizations_organization.organization.roots[0].id
  org_management_account_id = aws_organizations_organization.organization.master_account_id

  org_root_ids = [
    aws_organizations_organization.organization.roots[0].id,
    aws_organizations_organizational_unit.dffp.id,
    aws_organizations_organizational_unit.ryan.id,
  ]
  root_account_ids = [
    aws_organizations_account.management.id,
    aws_organizations_account.human.id,
    aws_organizations_account.infra.id
  ]
  dffp_account_ids = [
    aws_organizations_account.dffp_qual.id,
    aws_organizations_account.dffp_prod.id
  ]
  ryan_account_ids = [
    aws_organizations_account.ryan_qual.id,
    aws_organizations_account.ryan_prod.id
  ]
  all_account_ids = concat(local.root_account_ids, local.dffp_account_ids, local.ryan_account_ids)
}