data "aws_availability_zones" "available" {}

# Retrieve the latest Amazon Linux 2 AMI (owned by Amazon)
data "aws_ami" "nginx" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
