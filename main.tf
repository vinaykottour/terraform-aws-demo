resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name

  tags = {
    Name        = "Terraform Demo"
    Environment = var.environment
  }
}

module "networking" {
  source = "./modules/networking"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  environment        = var.environment
}

module "iam" {
  source = "./modules/iam"
}

module "ec2" {
  source = "./modules/ec2"

  ami_id               = "ami-08e3b3155fc937a94"
  instance_type        = var.instance_type
  subnet_id            = module.networking.public_subnet_id
  security_group_id    = module.networking.security_group_id
  iam_instance_profile = module.iam.instance_profile_name
  key_name             = "terraform-demo-key"
  environment          = var.environment
}
