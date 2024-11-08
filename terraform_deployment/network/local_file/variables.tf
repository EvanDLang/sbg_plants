variable "vpc_id" {
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
}

variable "public_subnet_ids" {
  type        = list(string)
}

variable "security_group_ecs_id" {
  type = string
}

variable "security_group_lb_id" {
  type = string
}

variable "aws_alb_target_group_app_id" {
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC cidr block for infastructure"
  type        = string
}
