output "security_group_lb_id" {
  value = module.network.security_group_lb_id
  description = ""
}

output "security_group_ecs_id" {
  value = module.network.security_group_ecs_id
  description = ""
}

output "subnet_public_ids" {
  value = module.network.subnet_public_ids
  description = ""
}

output "subnet_private_ids" {
  value = module.network.subnet_private_ids
  description = ""
}

output "vpc_id" {
  value = module.network.vpc_id
  description = ""
}
output "aws_alb_target_group_app_id" {
  value = module.loadbalancer.aws_alb_target_group_app_id
  description = ""
}
