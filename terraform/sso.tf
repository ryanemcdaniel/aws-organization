data "aws_ssoadmin_instances" "sso" {}

locals {
  sso_identity_store_id = tolist(data.aws_ssoadmin_instances.sso.identity_store_ids)[0]
  sso_instance_arn      = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
}