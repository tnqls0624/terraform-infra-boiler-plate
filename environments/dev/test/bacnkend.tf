terraform {
  backend "s3" {
    bucket  = "test-infra-tf-state-dev"
    key     = "test-infra.dev.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}