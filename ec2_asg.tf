# Define a Launch Template for the Nginx web servers
resource "aws_launch_template" "web_lt" {
  name_prefix   = "sandbox-web-"
  image_id      = data.aws_ami.nginx.id
  instance_type = "t3.micro"
  # Specify your key name if SSH access is required
  key_name = "poc1"

  # Associate the web security group with the instances
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Simple user data script to install and start Nginx
  user_data = base64encode(<<EOF
#!/bin/bash
sudo amazon-linux-extras install nginx1 -y
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
  )
}

# Create an Auto Scaling Group for web servers in the private subnets
resource "aws_autoscaling_group" "web_asg" {
  name = "sandbox-web-asg"
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [for s in aws_subnet.private : s.id]
  target_group_arns         = [aws_lb_target_group.web_tg.arn]
  min_size                  = 1
  max_size                  = 5
  desired_capacity          = 2
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "sandbox-web"
    propagate_at_launch = true
  }
}
