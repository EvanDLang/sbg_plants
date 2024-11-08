variable "name" {
  description = "Prefix name to assign to Nebari resources"
  type        = string
  default = "SBG Plants Database"
}

variable "availability_zones" {
  description = "AWS availability zones within AWS region"
  type        = list(string)
  default = ["us-west-2a", "us-west-2b"]
}

variable "vpc_cidr_block" {
  description = "VPC cidr block for infastructure"
  type        = string
  default = "172.17.0.0/16"
}

variable "tags" {
  description = "Additional tags to add to resources"
  type        = map(string)
  default     = {owner: "sbg-plants-database"}
}

variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default     = 5000
}
