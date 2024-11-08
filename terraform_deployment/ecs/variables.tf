variable "region" {
  description = "AWS region for EKS cluster"
  type        = string
  default = "us-west-2"
}

variable "tags" {
  description = "Additional tags to add to resources"
  type        = map(string)
  default     = {name: "sbg-plants"}
}

variable "ecs_auto_scale_role_name" {
    description = "ECS auto scale role name"
    default = "sbgPlantsAutoScaleRole"
}

variable "db_name" {
    description = "name of the postgres db"
    type        = string
    default       = "sbgplants"
}

variable "db_schema" {
    description = "name of the postgres db"
    type        = string
    default       = "sbg_plants"
}

variable "postgrest_user_password" {
    description = "name of the postgres db"
    type        = string
}

variable "postgrest_user_role" {
    description = "name of the postgres db"
    type        = string
}

variable "db_port" {
    description = "password for postgres db"
    default     = 5432
}

variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default     = 5000
}

variable "app_image" {
    description = "Docker image to run in the ECS cluster"
    default     = "public.ecr.aws/b6e9x3i9/pygeoapi_testing:latest"
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
    default = 1024
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = 2048
}
