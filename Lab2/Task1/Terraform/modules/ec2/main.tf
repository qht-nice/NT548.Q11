#EC2
resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  security_groups = [var.public_security_group.id]
  key_name = "TF_key"

  associate_public_ip_address = true

  tags = {
    Name = "Public_instance"
  }
}

resource "aws_instance" "private_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  security_groups = [var.private_security_group.id]
  key_name = "TF_key"

  tags = {
    Name = "Private_instance"
  }
}
