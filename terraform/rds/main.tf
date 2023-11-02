provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "../vpc"
}

# project/terraform/rds/main.tf

resource "aws_db_instance" "rdsinstance" {
allocated_storage    = 20
storage_type         = "gp2"
engine               = "mysql"
engine_version       = "5.7"
instance_class       = "db.t2.micro"
db_name              = "mydb"
username             = "admin"
password             = "admin1234"
parameter_group_name = "default.mysql5.7"
skip_final_snapshot  = true
auto_minor_version_upgrade = true
db_subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name
vpc_security_group_ids = [aws_security_group.rds_sg.id]
publicly_accessible = true
port = 3306
backup_retention_period = 7    # Number of days to retain automated backups
backup_window           = "03:00-04:00"  # Preferred backup window
 maintenance_window      = "wed:04:00-wed:05:00" 
}

# DB Subnet group

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name        = "my-db-subnet-group"
  description = "My DB Subnet Group"
  subnet_ids  = module.vpc.public_subnets
}

# Security group

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "RDS security group"
  vpc_id      = module.vpc.vpc_id

  // Ingress rules (allow incoming traffic)
  ingress {
    from_port   = 3306 # MySQL port
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  // Egress rules (allow outgoing traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"] 
  }
}
