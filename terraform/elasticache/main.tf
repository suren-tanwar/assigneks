provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "../vpc"
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name        = "my-db-subnet-group"
  description = "My DB Subnet Group"
  subnet_ids  = module.vpc.public_subnets
}


# project/terraform/elasticache/main.tf
resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "my-memcached-cluster"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.5"
  security_group_ids = [aws_security_group.mm_sg.id]
  subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name
}



resource "aws_security_group" "mm_sg" {
  name        = "mm-sg"
  description = "mm security group"
  vpc_id = module.vpc.vpc_id

  // Ingress rules (allow incoming traffic)
  ingress {
    from_port   = 3306 # MySQL port
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere (for demonstration purposes; tighten this in a production environment)
  }

  // Egress rules (allow outgoing traffic)
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic (for demonstration purposes; tighten this in a production environment)
  }
}