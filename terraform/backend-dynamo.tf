resource "aws_dynamodb_table" "backend_lock" {
  name     = "tf-ryanemcdaniel-management-lock"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  read_capacity  = 1
  write_capacity = 1
}

data "aws_iam_policy_document" "backend_lock" {
  version = "2012-10-17"
  statement {
    sid = "AllowReadWrite"
    principals {
      type        = "AWS"
      identifiers = [local.org_management_account_id]
    }
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [aws_dynamodb_table.backend_lock.arn]
  }
}

resource "aws_dynamodb_resource_policy" "backend_lock" {
  resource_arn = aws_dynamodb_table.backend_lock.arn
  policy       = data.aws_iam_policy_document.backend_lock.json
}