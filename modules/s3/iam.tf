// docs: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html#create-oac-overview-s3
data "aws_iam_policy_document" "public" {
  for_each = {for name in var.s3.names : name => name if var.s3.mode == "Public"}

  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    // TODO: condition 추가

    resources = [
      aws_s3_bucket.this[each.key].arn,
      "${aws_s3_bucket.this[each.key].arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "private" {
  for_each = {for name in var.s3.names : name => name if var.s3.mode != "Public"}

  version = "2012-10-17"

  statement {
    sid    = "DenyUnEncryptedObjectUploads"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:PutObject",
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms"]
    }

    resources = [
      aws_s3_bucket.this[each.key].arn,
      "${aws_s3_bucket.this[each.key].arn}/*"
    ]
  }

  statement {
    sid    = "DenyInsecureConnections"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    resources = [
      aws_s3_bucket.this[each.key].arn,
      "${aws_s3_bucket.this[each.key].arn}/*"
    ]
  }
}

