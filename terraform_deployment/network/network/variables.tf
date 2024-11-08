variable "name" {
  description = "Prefix name to assign to Nebari resources"
  type        = string
}


variable "availability_zones" {
  description = "AWS availability zones within AWS region"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "VPC cidr block for infastructure"
  type        = string
}

variable "tags" {
  description = "Additional tags to add to resources"
  type        = map(string)
}

variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
}