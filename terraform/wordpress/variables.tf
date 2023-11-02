
# variable "cluster_name" {}

# variable "node_group" {}


variable "wp_db_host" {}

variable "wp_db_pass"{}

variable "wp_db_user"{}

variable "wp_db_name"{}

variable "wordpress_image" {
  description = "WordPress Docker image to use"
  type        = string
  default     = "wordpress:latest"
}

