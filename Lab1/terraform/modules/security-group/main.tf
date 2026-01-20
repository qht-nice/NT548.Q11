resource "aws_security_group" "public_security_group" {
  name   = "allow_ssh_to_public"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow SSH from specified sources"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    name = "Public_security_group"
  }
}

resource "aws_security_group" "private_security_group" {
  name   = "allow_ssh_from_public"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow SSH from public instances"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    name = "Private_security_group"
  }
}