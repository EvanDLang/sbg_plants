
variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
}

variable "health_check_path" {
  default = "/"
}

variable "security_group_lb_id" {
    description = "ID of the security group associated with the load balancer"
}

variable "vpc_id" {
    description = "ID for the vpc"
}

variable "public_subnet_ids" {
    description = "IDs for the public subnets"
}
