# variable "database_subnet_group_name" {
#   description = "Name of the RDS subnet group"
#   type        = string
# }


# modules/vpc/variables.tf

# Define variables for VPC module
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_blocks" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for public subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}
