resource "aws_security_group" "public_security_group" {
  #checkov:skip=CKV2_AWS_5: SG is attached to EC2 via vpc_security_group_ids in ec2 module
  name        = "allow_ssh_to_public"
  description = "Public EC2 SG: allow SSH from allowed IP; limit egress to web + DNS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from specified sources"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]

  }

  egress {
    description = "Allow HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTP outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow DNS outbound (UDP)"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow DNS outbound (TCP)"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "Public_security_group"
  }
}

resource "aws_security_group" "private_security_group" {
  #checkov:skip=CKV2_AWS_5: SG is attached to EC2 via vpc_security_group_ids in ec2 module
  name        = "allow_ssh_from_public"
  description = "Private EC2 SG: allow SSH from public SG; limit egress to web + DNS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow SSH from public instances"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_security_group.id]
  }

  egress {
    description = "Allow HTTPS outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTP outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow DNS outbound (UDP)"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow DNS outbound (TCP)"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "Private_security_group"
  }
}