#Create an PostgreSql RDS
resource "aws_db_subnet_group" "default" {
  name        = "${var.app_name}-${var.env_type}-subnet-group"
  description = "Terraform example RDS subnet group"
  subnet_ids  = [ aws_subnet.subnet_private-A.id, aws_subnet.subnet_private-B.id ]
}


resource "aws_db_instance" "postgresql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "12.8"
  instance_class       = var.db_instance_type
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  multi_az             = "false"
  db_subnet_group_name      = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible = "false"
  apply_immediately = "true"
  identifier = "${var.app_name}-${var.env_type}-rds"
  skip_final_snapshot = "true"
  parameter_group_name = "default.postgres12"
  
}

output "RDS-Endpoint" {
  value = aws_db_instance.postgresql.address
}
