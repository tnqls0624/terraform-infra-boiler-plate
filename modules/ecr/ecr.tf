resource "aws_ecr_repository" "this" {
  name = "${var.name}-${var.sub_name}/${var.env}"
}

