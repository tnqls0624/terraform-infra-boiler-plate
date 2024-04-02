resource "aws_kms_key" "rds_encryption" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name = "${var.project.name}-${var.project.env}-rds-encryption"
    Env  = var.project.env
  }
}