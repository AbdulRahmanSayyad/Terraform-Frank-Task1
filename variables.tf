variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "allowed_ips" {
  description = "List of allowed public IPs for accessing the web service"
  type        = list(string)
  default     = ["152.59.205.219/32"]
}

variable "domain_name" {
  description = "The domain name to point to the ALB (e.g., app.example.com)"
  type        = string
  default     = "app.example.com"  # Replace with your actual domain if needed
}

variable "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for the domain"
  type        = string
  default     = "Z04051288PFTJM3MLF67"
}

