resource "aws_db_parameter_group" "instance" {
  name        = "${var.project.name}-${var.project.env}-instance-pg"
  description = "Aurora MySQL 8.0 Parameter Group"
  family      = "aurora-mysql8.0"

  tags = {
    Name = "${var.project.name}-${var.project.env}-instance-pg"
    Env  = var.project.env
  }
}

resource "aws_rds_cluster_instance" "this" {
  depends_on = [aws_rds_cluster.this]

  identifier         = "${var.project.name}-${var.project.env}-cluster-instance"
  cluster_identifier = aws_rds_cluster.this.cluster_identifier

  engine                     = "aurora-mysql"
  engine_version             = "8.0.mysql_aurora.3.04.0"
  instance_class             = "db.t3.medium"
  auto_minor_version_upgrade = true

  copy_tags_to_snapshot = false
  #  ca_cert_identifier    = "ca_cert_identifier"
  publicly_accessible   = var.rds.public_access

  availability_zone       = var.aws_config.region_a
  db_parameter_group_name = aws_db_parameter_group.instance.name
  db_subnet_group_name    = aws_db_subnet_group.this.name


  tags = {
    Name = "${var.project.name}-${var.project.env}-cluster-instance"
    Env  = var.project.env
  }
}
