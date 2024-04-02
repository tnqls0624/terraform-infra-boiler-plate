resource "aws_route53_zone" "this" {
  name = var.route53.name
}

data "aws_lb_hosted_zone_id" "alb_zone" {
}

resource "aws_route53_record" "this" {
  for_each = var.projects
  zone_id = aws_route53_zone.this.zone_id

  name = "${var.env}-${each.value.sub_name}.${var.route53.name}"
  type = "A"

  allow_overwrite = true // Record 덮어쓰기 허용

  alias {
    evaluate_target_health = true
    name                   = var.alb[each.key].dns_name
    zone_id                = data.aws_lb_hosted_zone_id.alb_zone.id
  }
}


#resource "aws_route53_record" "alb_record" {
#  for_each = {
#    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
#      name   = dvo.resource_record_name
#      record = dvo.resource_record_value
#      type   = dvo.resource_record_type
#    }
#  }
#
#  zone_id = data.aws_route53_zone.this.zone_id
#  name    = each.value.name
#  type    = each.value.type
#  records = [each.value.record]
#  allow_overwrite = true // Record 덮어쓰기 허용
#
#  alias {
#    evaluate_target_health = true
#    name                   = var.alb.dns_name
#    zone_id                = data.aws_lb_hosted_zone_id.alb_zone.id
#  }
#}

#resource "aws_acm_certificate_validation" "this" {
#  certificate_arn         = aws_acm_certificate.this.arn
#  validation_record_fqdns = [for record in aws_route53_record.alb_record : record.fqdn]
#}

