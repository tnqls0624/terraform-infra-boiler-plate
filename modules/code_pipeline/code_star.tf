# docs: https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html
# console: https://ap-northeast-2.console.aws.amazon.com/codesuite/settings/connections
data "aws_codestarconnections_connection" "this" {
  name          = "tnqls0624-git"
}
