data "aws_partition" "current" {}

data "local_file" "network_outputs" {
  filename = "../network_outputs.json"
}

locals {
    file_content = jsondecode(data.local_file.network_outputs.content)
}

locals {
    private_subnet_ids              = local.file_content.private_subnet_ids
    vpc_id  = local.file_content.vpc_id
    vpc_cidr_block = local.file_content.vpc_cidr_block
}

# ==================== RDS =============================

module "rds" {
  source = "./rds"  

  vpc_id              = local.vpc_id
  subnet_ids          = local.private_subnet_ids
  vpc_cidr_block      = local.vpc_cidr_block
  db_password         = var.db_password
  db_port             = var.db_port
  db_name             = var.db_name
  
}

# ====================== LOCAL_FILE ==============================

module "local_file" {
  source                      = "./local_file"
  
  db_instance_endpoint    = module.rds.db_instance_endpoint
  db_instance_username    = module.rds.db_instance_username
  db_instance_id          = module.rds.db_instance_id
}