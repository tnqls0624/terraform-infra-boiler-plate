resource "aws_alb" "this" {
  for_each = var.projects
  name = "${var.name}-${each.value.sub_name}-alb-${var.env}"

  load_balancer_type = "application" # ALB
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = var.vpc.subnet_ids

  internal = false

  timeouts {}

  tags = {
    Name = "${var.name}-${each.value.sub_name}-alb-${var.env}"
    env  = var.env
  }
}

resource "aws_alb_target_group" "this" {
  for_each = var.projects
  name = "${var.name}-${each.value.sub_name}-tg-${var.env}"

  vpc_id      = var.vpc.id
  target_type = "ip"
  port        = each.value.alb_container_port

  protocol         = "HTTP"
  protocol_version = "HTTP1"

  health_check {
    path                = "/ping"
    healthy_threshold   = 5 # default
    unhealthy_threshold = 2 # default
    timeout             = 5 # default
    interval            = 30 # default
    matcher             = "200" # default
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}-${each.value.sub_name}-tg-${var.env}"
    env  = var.env
  }
}

resource "aws_alb_listener" "http" {
  for_each = var.projects
  load_balancer_arn = aws_alb.this[each.key].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.this[each.key].arn
  }

#  default_action {
#    type = "redirect"
#
#    redirect {
#      host        = "#{host}"
#      path        = "/#{path}"
#      port        = "443"
#      protocol    = "HTTPS"
#      query       = "#{query}"
#      status_code = "HTTP_301"
#    }
#  }
}

#resource "aws_alb_listener" "https" {
#  load_balancer_arn = aws_alb.this.arn
#  certificate_arn   = data.aws_acm_certificate.this.arn
#  port              = 443
#  protocol          = "HTTPS"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_alb_target_group.this.arn
#  }
#}
