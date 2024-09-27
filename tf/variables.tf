
variable "env" {
  description = "Deployment environment"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "ami_id" {
  description = "EC2 Ubuntu AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use for EC2"
  type        = string
}

variable "s3_bucket" {
   type = string
}

variable "avalibilty_zone" {
   type = string
}