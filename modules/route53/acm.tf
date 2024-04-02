resource "aws_acm_certificate" "this" {
  domain_name       = "*.${var.route53.name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    project = var.route53.name
  }
}
