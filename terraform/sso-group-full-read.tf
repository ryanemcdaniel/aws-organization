

# ==
# Human Group - full read
# ==
resource "aws_identitystore_group" "human_full_read" {
    identity_store_id = local.sso_identity_store_id
    display_name      = "full-read"
    description       = "human - full read privilege group"
}

resource "aws_ssoadmin_permission_set" "human_full_read" {
    instance_arn     = local.sso_instance_arn
    name             = "full-read"
    description      = "human - full read privileges"
    session_duration = "PT2H"
}

resource "aws_ssoadmin_managed_policy_attachment" "human_full_read" {
    instance_arn       = local.sso_instance_arn
    managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    permission_set_arn = aws_ssoadmin_permission_set.human_full_read.arn
    depends_on         = [aws_ssoadmin_account_assignment.human_full_read]
}

resource "aws_ssoadmin_account_assignment" "human_full_read" {
    for_each           = local.environment_accounts
    instance_arn       = local.sso_instance_arn
    permission_set_arn = aws_ssoadmin_permission_set.human_full_read.arn
    principal_type     = "GROUP"
    principal_id       = aws_identitystore_group.human_full_read.group_id
    target_type        = "AWS_ACCOUNT"
    target_id          = each.value
}