resource "local_sensitive_file" "network_outputs" {

  filename = "../network_outputs.json"
  
  content = jsonencode({
    private_subnet_ids               = var.private_subnet_ids
    public_subnet_ids                = var.public_subnet_ids
    security_group_ecs_id            = var.security_group_ecs_id
    security_group_lb_id            = var.security_group_lb_id
    aws_alb_target_group_app_id  = var.aws_alb_target_group_app_id
    vpc_id = var.vpc_id
    vpc_cidr_block              = var.vpc_cidr_block
  })
}
