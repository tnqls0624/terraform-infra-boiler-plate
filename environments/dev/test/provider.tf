provider "aws" {
  region                  = "ap-northeast-2"
  shared_config_files     = ["~/.aws/config"]
  profile                 = "default"

  assume_role {
    role_arn     = "arn:aws:iam::${local.ACCOUNT_ID}:role/switch_role"
  }
}
