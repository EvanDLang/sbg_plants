output "security_group_lb_id" {
  description = "AWS security group id"
  value       = aws_security_group.lb.id
}

output "security_group_ecs_id" {
  description = "AWS security group id"
  value       = aws_security_group.ecs_tasks.id
}

output "subnet_public_ids" {
  description = "AWS VPC subnet ids"
  value       = aws_subnet.public[*].id
}

output "subnet_private_ids" {
  description = "AWS VPC subnet ids"
  value       = aws_subnet.private[*].id
}

output "vpc_id" {
  description = "AWS VPC id"
  value       = aws_vpc.main.id
}
