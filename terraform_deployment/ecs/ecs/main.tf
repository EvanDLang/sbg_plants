
resource "aws_ecs_cluster" "main" {
    name = "sbg-plants-cluster"
}
data "template_file" "cb_app" {
    template = file("./templates/ecs/pygeoapi.json.tpl")

    vars = {
        app_image      = var.app_image
        app_port       = var.app_port
        fargate_cpu    = var.fargate_cpu
        fargate_memory = var.fargate_memory
        aws_region     = var.aws_region
        endpoint       = var.endpoint
        db_port        = var.db_port
        db_name = var.db_name
        postgrest_user_password = var.postgrest_user_password
        db_schema = var.db_schema
        postgrest_user_role = var.postgrest_user_role
    }
}

resource "aws_ecs_task_definition" "app" {
    family                   = "sbg-plants-pygeoapi"
    execution_role_arn       = var.execution_role_arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]

    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory 
    container_definitions    = data.template_file.cb_app.rendered
}

resource "aws_ecs_service" "main" {
    name            = "cb-app-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count   = var.app_count
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [var.security_group_ecs_id]
        subnets          = var.subnet_ids
        assign_public_ip = false
    }

    load_balancer {
        target_group_arn = var.aws_alb_target_group_app_id
        container_name   = "cb-app"
        container_port   = var.app_port
    }

    #depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment]
}