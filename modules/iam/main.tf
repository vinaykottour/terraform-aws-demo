
# IAM role that EC2 assumes for Systems Manager access
resource "aws_iam_role" "ec2_ssm" {
  name = "terraform-demo-ec2-ssm-role"

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
}

# Attach the AWS-managed policy for Systems Manager
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile that makes the IAM role available to EC2
resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "terraform-demo-ec2-instance-profile"
  role = aws_iam_role.ec2_ssm.name
}
