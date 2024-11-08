data "aws_partition" "current" {}

data "local_file" "network_outputs" {
  filename = "../network_outputs.json"
}

data "local_file" "database_outputs" {
  filename = "../database_outputs.json"
}


locals {
    network_file_content = jsondecode(data.local_file.network_outputs.content)
    database_file_content = jsondecode(data.local_file.database_outputs.content)
}

locals {
    private_subnet_ids              = local.network_file_content.private_subnet_ids
    aws_alb_target_group_app_id     = local.network_file_content.aws_alb_target_group_app_id
    security_group_ecs_id           = local.network_file_content.security_group_ecs_id
    db_instance_endpoint            = local.database_file_content.db_instance_endpoint
 
}


# ==================== IAM =============================

module "iam" {

    source                 = "./iam"
    ecs_auto_scale_role_name = var.ecs_auto_scale_role_name

}
# ======================== ECS ========================
module "ecs" {

    source                        = "./ecs"

    aws_region                    = var.region
    app_port                      = var.app_port
    fargate_cpu                   = var.fargate_cpu
    fargate_memory                = var.fargate_memory
    app_image                     = var.app_image
    app_count                     = var.app_count
    subnet_ids                    = local.private_subnet_ids
    security_group_ecs_id         = local.security_group_ecs_id
    aws_alb_target_group_app_id   = local.aws_alb_target_group_app_id 
    execution_role_arn            = module.iam.execution_role_arn
    db_port                       = var.db_port
    endpoint                      = local.db_instance_endpoint
    db_name                       = var.db_name
    db_schema                     = var.db_schema
    postgrest_user_password       = var.postgrest_user_password
    postgrest_user_role           = var.postgrest_user_role
    
}

# ==================== AUTOSCALLING =================

module "autoscaling" {

    source         = "./autoscaling"

    ecs_cluster_name = module.ecs.ecs_cluster_name
    ecs_service_name = module.ecs.ecs_service_name
    autoscale_role_arn = module.iam.autoscale_role_arn
}

