variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "ami" {}
variable "instance_type" {}
variable "public_security_group_id" {
  type = string
}

variable "private_security_group_id" {
  type = string
}