variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}
variable "cidr_private_subnet" {
    default = "10.0.2.0/24"
}
variable "cidr_public_subnet" {
    default = "10.0.1.0/24"
}
variable "ami" {
    default = "ami-0ecb62995f68bb549"
    description = "AMI ID for EC2 instances"
}
variable "instance_type" {
    default = "t3.small"
}

variable "allowed_ssh_ip" {
    description = "IP address allowed to SSH to public instances"
    type        = string
    default     = "0.0.0.0/0"
}

