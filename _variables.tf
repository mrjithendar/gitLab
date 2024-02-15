variable "environment" {
  default = "demo"
}

variable "email" {
  default = "i@jithendar.com"
}

variable "userid" {
  default = "jdharmapuri"
}

variable "level" {
  default = "trainer"
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}