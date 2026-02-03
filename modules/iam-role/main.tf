# IAM Role for EC2 to access SSM
resource "aws_iam_role" "this" {
  name = "${var.name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge({
    Name = "${var.name}-ssm-role"
  }, var.tags)
}

# ---------------------------
# Policy Attachments (FULL ACCESS)
# ---------------------------

# EC2 FULL access
resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# VPC FULL access
resource "aws_iam_role_policy_attachment" "vpc" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

# S3 FULL access
resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# DynamoDB FULL access
resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# Attach AWS managed SSM policy
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile (needed for EC2)
resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-ssm-instance-profile"
  role = aws_iam_role.this.name
}
