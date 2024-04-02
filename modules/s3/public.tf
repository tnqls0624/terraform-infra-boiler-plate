// docs: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-policies.html
resource "aws_s3_bucket_policy" "public" {
  for_each = {for name in var.s3.names : name => name if var.s3.mode == "Public"}

  depends_on = [aws_s3_bucket_acl.this]

  bucket = aws_s3_bucket.this[each.key].id
  policy = data.aws_iam_policy_document.public[each.key].json
}
