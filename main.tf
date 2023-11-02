provider "aws" {
  region = "ap-south-1"
}

module "s3" {
  source = "./terraform/s3"
}

module "eks_module" {
  source = "./terraform/eks"
  eks_cluster_name = "my-eks-cluster"
  eks_cluster_version =  "1.27"
}

module "rds_module" {
  source = "./terraform/rds"
}

module "elasticache" {
  source = "./terraform/elasticache"
}

module "vpc" {
  source = "./terraform/vpc"
}

module "wordpress" {
  source = "./terraform/wordpress"
  wp_db_user = module.rds_module.rds_db_user
  wp_db_pass = module.rds_module.rds_db_pass
  wp_db_name = module.rds_module.rds_db_name
  wp_db_host   = module.rds_module.rds_db_host

}
# output "wp_hostname" {
#   value       = module.wordpress.wordpress_hostname
# }




