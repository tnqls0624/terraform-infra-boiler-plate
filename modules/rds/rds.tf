resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = "${var.project.name}-${var.project.env}-cluster-pg"
  description = "Customized Default cluster parameter group for aurora-mysql8.0"
  family      = "aurora-mysql8.0"

  tags = {
    Name = "${var.project.name}-${var.project.env}-cluster-pg"
    Env  = var.project.env
  }
}

resource "aws_db_subnet_group" "this" {
  name        = "${var.project.name}-${var.project.env}-db-subnet-group"
  description = "Subnet group for ${var.project.name}-${var.project.env}-cluster"

  subnet_ids = var.vpc.subnet_ids

  tags = {
    Name = "${var.project.name}-${var.project.env}-db-subnet-group"
    Env  = var.project.env
  }
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = "${var.project.name}-cluster-${var.project.env}"

  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  engine_version = "8.0.mysql_aurora.3.04.0"

  storage_encrypted = true

  master_username = "admin"
  master_password = "chltjdals22!"
  port            = 3306

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster.name
  db_subnet_group_name            = aws_db_subnet_group.this.name

  network_type           = "IPV4"
  vpc_security_group_ids = [aws_security_group.rds_all.id]

  copy_tags_to_snapshot        = true
  preferred_backup_window      = "13:16-13:46"
  preferred_maintenance_window = "sun:15:42-sun:16:12"
  skip_final_snapshot          = true

  kms_key_id = aws_kms_key.rds_encryption.arn

  serverlessv2_scaling_configuration {
    max_capacity = 128
    min_capacity = 0.5
  }

  tags = {
    Name = "${var.project.name}-${var.project.env}-cluster"
    Env  = var.project.env
  }
}
