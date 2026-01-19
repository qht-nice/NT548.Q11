terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.11"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1"
}

# Key
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}

# VPC
module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr_block      = var.vpc_cidr_block
  cidr_public_subnet  = var.cidr_public_subnet
  cidr_private_subnet = var.cidr_private_subnet
}

# Nat_gateway
module "nat_gateway" {
  source            = "./modules/nat-gateway"
  public_subnet_id  = module.vpc.public_subnet_id
  internet_gateway  = module.vpc.internet_gateway
  private_subnet_id = module.vpc.private_subnet_id
  vpc_id            = module.vpc.vpc_id
}

#Security Groups
module "security_group" {
  source         = "./modules/security-group"
  vpc_id         = module.vpc.vpc_id
  allowed_ssh_ip = var.allowed_ssh_ip
}

#EC2
module "ec2" {
  source                    = "./modules/ec2"
  ami                       = var.ami
  instance_type             = var.instance_type
  public_subnet_id          = module.vpc.public_subnet_id
  private_subnet_id         = module.vpc.private_subnet_id
  public_security_group_id  = module.security_group.public_security_group_id
  private_security_group_id = module.security_group.private_security_group_id
}

# Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway.id
}

output "nat_gateway_id" {
  value = module.nat_gateway.nat_gateway_id
}

output "nat_gateway_public_ip" {
  value = module.nat_gateway.nat_gateway_public_ip
}

output "public_security_group_id" {
  value = module.security_group.public_security_group_id
}

output "private_security_group_id" {
  value = module.security_group.private_security_group_id
}

output "public_instance_id" {
  value = module.ec2.public_instance_id
}

output "public_instance_public_ip" {
  value = module.ec2.public_instance_public_ip
}

output "public_instance_private_ip" {
  value = module.ec2.public_instance_private_ip
}

output "private_instance_id" {
  value = module.ec2.private_instance_id
}

output "private_instance_private_ip" {
  value = module.ec2.private_instance_private_ip
}

