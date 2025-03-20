# Security Group for the Application Load Balancer – restricts access to allowed IPs only
resource "aws_security_group" "alb_sg" {
  name        = "sandbox-alb-sg"
  description = "Allow HTTP/HTTPS access from allowed IPs only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sandbox-alb-sg"
  }
}

# Security Group for the web servers – allows traffic from the ALB only
resource "aws_security_group" "web_sg" {
  name        = "sandbox-web-sg"
  description = "Allow traffic from the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sandbox-web-sg"
  }
}

# Security Group for RDS – allows inbound DB connections only from web servers
resource "aws_security_group" "rds_sg" {
  name        = "sandbox-rds-sg"
  description = "Allow PostgreSQL traffic from web servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sandbox-rds-sg"
  }
}
