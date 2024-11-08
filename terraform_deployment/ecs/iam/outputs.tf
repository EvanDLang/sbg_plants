output "autoscale_role_arn" {
    description = ""
    value       = aws_iam_role.ecs_auto_scale_role.arn
}
output "execution_role_arn" {
    description = ""
    value       = aws_iam_role.ecs_task_execution_role.arn
}