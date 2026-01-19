variable "vpc_id" {}
variable "allowed_ssh_ip" {
  description = "IP address allowed to SSH to public instances"
  type        = string
  default     = "0.0.0.0/0"
}