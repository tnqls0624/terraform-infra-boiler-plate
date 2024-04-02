# ALB
output "alb" {
  description = "ALB Outputs"
  value = { for key, alb in aws_alb.this : key => {
    target_group_arn = try(aws_alb_target_group.this[key].arn, "")
    dns_name         = try(alb.dns_name, "")
    arn              = try(alb.arn, "")
  }}
}

#output "alb" {
#  description = <<EOT
#  ALB Outputs
#  - target_group_arn: The ARN of the target group
#  - dns_name: The DNS name of the load balancer
#  - arn: The ARN of the load balancer
#EOT
#  value = { for k, v in aws_alb.this : k => {
#    arn = v.arn
#    dns_name = v.dns_name
#    target_group_arn = aws_alb_target_group.this[k].arn
#  }}
#}
