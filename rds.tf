# Create a DB subnet group using the private subnets
resource "aws_db_subnet_group" "rds_subnets" {
  name       = "sandbox-rds-subnet-group"
  subnet_ids = [for s in aws_subnet.private : s.id]

  tags = {
    Name = "sandbox-rds-subnet-group"
  }
}

# Create a highly available (multi-AZ) RDS PostgreSQL instance
resource "aws_db_instance" "rds" {
  identifier              = "sandbox-rds-instance"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "17.2"  # Ensure this version is valid in your region
  instance_class          = "db.t3.micro"
  db_name                 = "mydatabase"  # Use db_name instead of name
  username                = "adminuser"
  password                = "ChangeMe123!" # In production, store securely
  db_subnet_group_name    = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = true
  storage_encrypted       = true
  backup_retention_period = 7
  skip_final_snapshot     = true
  publicly_accessible     = false

  tags = {
    Name = "sandbox-rds-instance"
  }
}
