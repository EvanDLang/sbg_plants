resource "local_sensitive_file" "database_outputs" {

  filename = "../database_outputs.json"
  
  content = jsonencode({
    db_instance_endpoint      = var.db_instance_endpoint
    db_instance_username      = var.db_instance_username
    db_instance_id            = var.db_instance_id
  })
}
