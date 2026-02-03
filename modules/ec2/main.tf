resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx

              echo "<h1>This is my ${upper(var.environment)} server</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = merge({
    Name        = "${var.name}-ec2"
    Environment = var.environment
  }, var.tags)
}
