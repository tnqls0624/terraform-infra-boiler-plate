resource "aws_s3_bucket" "this" {
  for_each = toset(var.s3.names)

  bucket = "${var.name}-${var.project.sub_name}-${var.env}-${each.key}"

  force_destroy = false // 버킷에 객체가 있을 경우 삭제를 막는다.

  tags = {
    name = "${var.name}-${var.project.sub_name}-${var.env}-${each.key}"
    env  = var.env
  }
}

// docs: https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html
resource "aws_s3_bucket_ownership_controls" "this" {
  for_each = {for name in var.s3.names : name => name if var.s3.mode == "Public"}

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    object_ownership = "BucketOwnerPreferred" // 객체 소유자가 버킷 소유자가 되도록 설정
  }
}

// docs: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
resource "aws_s3_bucket_public_access_block" "this" {
  for_each = {for name in var.s3.names : name => name if var.s3.mode == "Public"}

  bucket = aws_s3_bucket.this[each.key].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

// docs: https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html
resource "aws_s3_bucket_acl" "this" {
  for_each = {for name in var.s3.names : name => name if var.s3.mode == "Public"}

  depends_on = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this
  ]

  bucket = aws_s3_bucket.this[each.key].id

  // 소유자는 FULL_CONTROL을 가집니다. AllUsers 그룹은 READ 액세스 권한을 가집니다.
  acl = "public-read"
}

// docs: https://docs.aws.amazon.com/AmazonS3/latest/userguide/EnableWebsiteHosting.html
resource "aws_s3_bucket_website_configuration" "this" {
  for_each = {for name in var.s3.names : name => name if var.s3.mode == "Public"}

  bucket = aws_s3_bucket.this[each.key].id

  // 호스팅 웹 사이트의 인덱스 문서를 지정
  index_document {
    suffix = "index.html"
  }

  // 호스팅 웹 사이트의 오류 문서를 지정
  error_document {
    key = "index.html"
  }
}

// docs: https://docs.aws.amazon.com/AmazonS3/latest/userguide/manage-versioning-examples.html
resource "aws_s3_bucket_versioning" "this" {
  for_each = {for name in var.s3.names : name => name if var.s3.mode == "Public"}

  bucket = aws_s3_bucket.this[each.key].id

  versioning_configuration {
    status     = "Enabled" // 버전 관리 활성화
    mfa_delete = "Disabled" // MFA 삭제 비활성화
  }
}

// docs: https://docs.aws.amazon.com/AmazonS3/latest/userguide/specifying-s3-encryption.html
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = {for name in var.s3.names : name => name if var.s3.mode == "Public"}

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    bucket_key_enabled = true // 버킷 키를 사용하여 객체를 암호화

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
