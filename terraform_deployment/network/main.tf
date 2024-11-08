data "aws_availability_zones" "awszones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_partition" "current" {}

# ======================= NETWORK ======================
module "network" {

  source                 = "./network"

  name                   = var.name
  tags                   = var.tags
  vpc_cidr_block         = var.vpc_cidr_block
  app_port               = var.app_port

  availability_zones = length(var.availability_zones) >= 2 ? var.availability_zones : slice(sort(data.aws_availability_zones.awszones.names), 0, 2)
}

# ======================= NATGATEWAY REPLACEMENT ======================
#module "fck-nat" {
#  source                = "git::https://github.com/RaJiska/terraform-aws-fck-nat.git"
#  count                 = length(var.availability_zones)
#
#  name                  = "natgateway-${count.index}"
#  vpc_id                = module.network.vpc_id
#  subnet_id             = module.network.subnet_public_ids[count.index]
#  ha_mode               = true
#  instance_type         = "t4g.nano"
#  #use_spot_instances   = true
#
#  
#
#  update_route_tables   = true
#  
#  route_tables_ids = {
#    private        = module.network.private_route_table_ids[count.index]
#  }
#
#  tags = {
#    Name           = "natgateway-${count.index}"
#  }
#}

# attach smce ssm agent policies

#resource "aws_iam_role_policy_attachment" "policy-attachment-ssm" {
#  count          = length(var.availability_zones)
#  role           = module.fck-nat[count.index].name
#  policy_arn     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#}

#resource "aws_iam_role_policy_attachment" "policy-attachment-agent-admin" {
#  count          = length(var.availability_zones)
#  role           = module.fck-nat[count.index].name
#  policy_arn     = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
#}

#resource "aws_iam_role_policy_attachment" "policy-attachment-agent-server" {
#  count          = length(var.availability_zones)
#  role           = module.fck-nat[count.index].name
#
#  policy_arn     = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
#}


# ===================== LOADBALANCER =====================

module "loadbalancer" {
    source = "./loadbalancer"

    security_group_lb_id = module.network.security_group_lb_id
    vpc_id               = module.network.vpc_id
    public_subnet_ids    = module.network.subnet_public_ids
    app_port             = var.app_port

}

# ====================== LOCAL_FILE ==============================

module "local_file" {
  source                      = "./local_file"
  
  vpc_id                      = module.network.vpc_id
  public_subnet_ids           = module.network.subnet_public_ids
  private_subnet_ids          = module.network.subnet_private_ids
  security_group_lb_id        = module.network.security_group_lb_id
  security_group_ecs_id       = module.network.security_group_ecs_id
  aws_alb_target_group_app_id = module.loadbalancer.aws_alb_target_group_app_id
  vpc_cidr_block              = var.vpc_cidr_block
}