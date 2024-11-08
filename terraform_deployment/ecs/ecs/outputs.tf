output "ecs_cluster_name" {
    description = ""
    value = aws_ecs_cluster.main.name
}


output "ecs_service_name" {
    description = ""
    value = aws_ecs_service.main.name
}