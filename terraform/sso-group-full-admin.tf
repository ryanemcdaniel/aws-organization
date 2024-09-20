# ==
# SSO Admin Group
# ==
resource "aws_identitystore_group" "full_admin" {
    identity_store_id = local.sso_identity_store_id
    display_name      = "full-admin"
    description       = "full admin privilege group"
}

resource "aws_ssoadmin_permission_set" "full_admin" {
    instance_arn     = local.sso_instance_arn
    name             = "full-admin"
    description      = "full admin privileges"
    session_duration = "PT12H"
}

resource "aws_ssoadmin_managed_policy_attachment" "full_admin" {
    instance_arn       = local.sso_instance_arn
    managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    permission_set_arn = aws_ssoadmin_permission_set.full_admin.arn
    depends_on         = [aws_ssoadmin_account_assignment.full_admin]
}

resource "aws_ssoadmin_account_assignment" "full_admin" {
    for_each           = var.accounts
    instance_arn       = local.sso_instance_arn
    permission_set_arn = aws_ssoadmin_permission_set.full_admin.arn
    principal_type     = "GROUP"
    principal_id       = aws_identitystore_group.full_admin.group_id
    target_type        = "AWS_ACCOUNT"
    target_id          = each.value.id
}