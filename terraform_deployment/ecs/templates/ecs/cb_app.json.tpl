[
  {
    "name": "cb-app",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/cb-app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "environment": [
    {
      "name": "PGRST_DB_URI",
      "value": "postgres://authenticator:${postgrest_user_password}@${endpoint}:${db_port}/${db_name}"
    },
    {
      "name": "PGRST_DB_SCHEMA",
      "value": "${db_schema}"
    },
    {
      "name": "PGRST_DB_ANON_ROLE",
      "value": "${postgrest_user_role}"
    }
  ]
  
  }
]