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
    default = "ami-09d0f541181899dd7"  
    description = "AMI ID for EC2 instances"
}
variable "instance_type" {
    default = "t3.small"
}

