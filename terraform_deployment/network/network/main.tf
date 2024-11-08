resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge({ Name = var.name }, var.tags)
}


resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  availability_zone       = var.availability_zones[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, length(var.availability_zones) + count.index)
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = merge({ Name = "${var.name}-subnet-${count.index}" }, var.tags)

  lifecycle {
    ignore_changes = [
      availability_zone
    ]
  }
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  availability_zone       = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.main.id

  tags = merge({ Name = "${var.name}-subnet-${count.index}" }, var.tags)

  lifecycle {
    ignore_changes = [
      availability_zone
    ]
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge({ Name = var.name }, var.tags)
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
#resource "aws_eip" "gw" {
#    count      = length(var.availability_zones)
#    domain = "vpc"
#    depends_on = [aws_internet_gateway.main]
#}

#resource "aws_nat_gateway" "gw" {
#    count         = length(var.availability_zones)
#    subnet_id     = element(aws_subnet.public.*.id, count.index)
#    allocation_id = element(aws_eip.gw.*.id, count.index)
#}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
    route_table_id         = aws_vpc.main.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.main.id
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
    count  = length(var.availability_zones)
    vpc_id = aws_vpc.main.id

    #route {
    #    cidr_block     = "0.0.0.0/0"
    #    nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
    #}
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
    count          = length(var.availability_zones)
    subnet_id      = element(aws_subnet.private.*.id, count.index)
    route_table_id = element(aws_route_table.private.*.id, count.index)
}


# ALB security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
    name        = "database-load-balancer-security-group"
    description = "controls access to the ALB"
    vpc_id      = aws_vpc.main.id

    ingress {
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
    name        = "cb-ecs-tasks-security-group"
    description = "allow inbound access from the ALB only"
    vpc_id      = aws_vpc.main.id

    ingress {
        protocol        = "tcp"
        from_port       = var.app_port
        to_port         = var.app_port
        security_groups = [aws_security_group.lb.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create a security group for the bastion instance
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for the bastion host"
  vpc_id      = aws_vpc.main.id

  // Allow SSH access from your IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks = ["data.external.get_my_ip.result/32"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "bastion-key" {
  key_name   = "bastion-key"
  public_key = file("~/.ssh/bastion-key.pub")  # Path to your public key file
}

# Create a bastion instance

resource "aws_instance" "bastion_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro" 
  subnet_id              = aws_subnet.public.*.id[0]
  security_groups        = [aws_security_group.bastion_sg.id]
  key_name               = "bastion-key"
  associate_public_ip_address = true
  iam_instance_profile = "SMCE_SSMAgent"


  tags = {
    Name = "bastion-instance"
  }
}