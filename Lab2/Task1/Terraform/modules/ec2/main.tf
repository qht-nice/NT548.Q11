#EC2
resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [var.public_security_group.id]
  key_name               = "vockey"

  associate_public_ip_address = true

  tags = {
    Name = "Public_instance"
  }
}

resource "aws_instance" "private_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  vpc_security_group_ids = [var.private_security_group.id]
  key_name               = "vockey"

  tags = {
    Name = "Private_instance"
  }
}
