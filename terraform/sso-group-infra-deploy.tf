# ==
# Infra - Deploy (pipeline/local admin)
# ==
resource "aws_identitystore_group" "human_infra_deploy" {
    identity_store_id = local.sso_identity_store_id
    display_name      = "infra-read"
    description       = "human - infra deploy privilege group"
}

resource "aws_ssoadmin_permission_set" "human_infra_deploy" {
    instance_arn     = local.sso_instance_arn
    name             = "infra-read"
    description      = "human - infra deploy privileges"
    session_duration = "PT2H"
}

resource "aws_ssoadmin_managed_policy_attachment" "human_infra_deploy" {
    instance_arn       = local.sso_instance_arn
    managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    permission_set_arn = aws_ssoadmin_permission_set.human_infra_deploy.arn
#     depends_on         = [aws_ssoadmin_account_assignment.human_infra_deploy]
}

resource "aws_ssoadmin_account_assignment" "human_infra_deploy" {
    for_each           = local.environment_accounts
    instance_arn       = local.sso_instance_arn
    permission_set_arn = aws_ssoadmin_permission_set.human_infra_deploy.arn
    principal_type     = "GROUP"
    principal_id       = aws_identitystore_group.human_full_read.group_id
    target_type        = "AWS_ACCOUNT"
    target_id          = each.value
}