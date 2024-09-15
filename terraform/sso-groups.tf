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
  count = length(local.all_account_ids)

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.full_admin.arn
  principal_type     = "GROUP"
  principal_id       = aws_identitystore_group.full_admin.group_id
  target_type        = "AWS_ACCOUNT"
  target_id          = local.all_account_ids[count.index]
}

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
  count = length(local.all_account_ids)

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.human_full_read.arn
  principal_type     = "GROUP"
  principal_id       = aws_identitystore_group.human_full_read.group_id
  target_type        = "AWS_ACCOUNT"
  target_id          = local.all_account_ids[count.index]
}

# ==
# Infra (deploy) Group
# ==