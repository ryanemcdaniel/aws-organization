# ==
# Infra - Read (tfplan locally)
# ==
resource "aws_identitystore_group" "human_infra_read" {
    identity_store_id = local.sso_identity_store_id
    display_name      = "infra-deploy"
    description       = "human - infra read privilege group"
}

resource "aws_ssoadmin_permission_set" "human_infra_read" {
    instance_arn     = local.sso_instance_arn
    name             = "infra-deploy"
    description      = "human - infra read privileges"
    session_duration = "PT2H"
}

resource "aws_ssoadmin_managed_policy_attachment" "human_infra_read" {
    instance_arn       = local.sso_instance_arn
    managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    permission_set_arn = aws_ssoadmin_permission_set.human_infra_read.arn
    depends_on         = [aws_ssoadmin_account_assignment.human_infra_read]
}

resource "aws_ssoadmin_account_assignment" "human_infra_read" {
    for_each           = local.environment_accounts
    instance_arn       = local.sso_instance_arn
    permission_set_arn = aws_ssoadmin_permission_set.human_infra_read.arn
    principal_type     = "GROUP"
    principal_id       = aws_identitystore_group.human_infra_read.group_id
    target_type        = "AWS_ACCOUNT"
    target_id          = each.value
}