#EC2
resource "aws_instance" "public_instance" {
  #checkov:skip=CKV_AWS_88: Public instance is required by the lab (reachable from Internet via SSH)
  #checkov:skip=CKV2_AWS_41: VocLabs role often blocks iam:CreateRole/InstanceProfile; skip IAM instance profile requirement
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.public_security_group_id]
  key_name               = "vockey"

  associate_public_ip_address = true

  monitoring    = true
  ebs_optimized = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  tags = {
    Name = "Public_instance"
  }
}

resource "aws_instance" "private_instance" {
  #checkov:skip=CKV2_AWS_41: VocLabs role often blocks iam:CreateRole/InstanceProfile; skip IAM instance profile requirement
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_security_group_id]
  key_name               = "vockey"

  monitoring    = true
  ebs_optimized = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  tags = {
    Name = "Private_instance"
  }
}
