variable "aws_region" {
    description = ""
}

variable "app_image" {
    description = "Docker image to run in the ECS cluster"
}

variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
}

variable "app_count" {
    description = "Number of docker containers to run"
    default = 1
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
}


variable "security_group_ecs_id" {
    description = "ID of the security group associated with the load balancer"
}

variable "subnet_ids" {
    description = "IDs for the private subnets"
}

variable "aws_alb_target_group_app_id" {
    description = ""
}

variable "execution_role_arn" {
    description = ""
}
variable "db_port" {
    description = "password for postgres db"
    type        = string
}

variable "endpoint" {
    description = "password for postgres db"
    type        = string
}

variable "db_name" {
    description = "name of the postgres db"
    type        = string
}

variable "db_schema" {
    description = "name of the postgres db"
    type        = string
}

variable "postgrest_user_password" {
    description = "name of the postgres db"
    type        = string
}

variable "postgrest_user_role" {
    description = "name of the postgres db"
    type        = string
}