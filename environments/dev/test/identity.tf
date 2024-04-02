locals {
  ACCOUNT_ID = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = local.ACCOUNT_ID
}