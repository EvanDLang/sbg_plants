variable "db_password" {
  description = "password for postgres db"
  type        = string
}

variable "db_port" {
    description = "password for postgres db"
    default     = 5432
}

variable "db_name" {
    description = "name of the postgres db"
    type        = string
    default       = "sbgplants"
}