# assigneks
Step-by-Step Guide:

Prerequisites
AWS account with appropriate permissions.
Terraform installed on  local machine.
AWS CLI installed and configured.
A WordPress application  Docker image.
Domain name for  website.
Created AWS IAM user with all the required policies for EKS.
Created a AWS configure profile with the same IAM user using AWS CLI command.
To use terraform modules for each task created 3 directories for EKS,RDS and Wordpress deployment module.
Created one main.tf terraform file.


Infrastructure Setup

Step 1: Set Up Terraform
Created a directory for your Terraform project.
Initialized Terraform in the project directory.
Created a backend configuration for storing Terraform state in an S3 bucket.

Step 2: Define Terraform Configuration
Created a main.tf file to define your infrastructure using Terraform.
Define the following components:
Amazon VPC and Subnets.
Amazon EKS Cluster.
Amazon RDS Database.
Amazon S3 Bucket for Terraform state.
Amazon ElastiCache Memcached Cluster.

Step 3: Configure Kubernetes
Set up  Kubernetes cluster for  WordPress application.
Created a VPC named eks_vpc, and 2 public subnets EKS Cluster to use it.
Creating Internet Gateway for public subnets, one route table and associate it with both the subnets.
Created IAM role for for creating EKS Cluster and attach the required policies policies i.e AmazonEKSClusterPolicy and AmazonEKSServicePolicy.
Created a EKS cluster  and make this resource to depend on the IAM role policies attachment and subnets resources.
EKS Cluster created IAM role for EKS Node group and attach the required policies.
created a EKS node group having maximum and desired 2 nodes , minimum 1 node. 
Deploy application code, including necessary resources like Deployment and Service objects.


Step4 RDS Module

Created 3 terraform files main.tf, outputs.tf and variables.tf.
main.tf
Created a DB subnet group that is used by RDS while creating a DB server.
Created a security group that is nothing but a firewall for RDS DB which decides who can connect to the database server. Add allow ingress rule with port 3306 for MySQL to only clients that comes with the security group that is associated by EKS.
Created RDS database with MySQL Engine with desired specifications and provide the DB subnet group and security group, password for DB is entered using variable at run time.

outputs.tf
The host address, user name and database name of RDS DB is used by WordPress deployment module it is required to output them.

variables.tf
Created these variables that is used in this module and are assigned during run time from different modules.

Step 5: Configure WordPress
Configure your WordPress application to use the RDS database as its backend.
Store sensitive data, like database credentials, securely using Kubernetes Secrets.
WordPress Deployment Module

Created 3 terraform files main.tf, outputs.tf and variables.tf.
Created WordPress container and use variables that are assigned the values from outputs of RDS module.
Created a loadbalencer of type "LoadBalencer" that will use external AWS loadbalencer using kubernetes service resource.
Output the host address of the loadbalencer where the WordPress portal is hosted and that is displayed using main file.


Step 6: Install Certbot
Install Certbot on the server where WordPress application is hosted.
sudo apt install certbot python3-certbot-apache
sudo certbot renew --dry-run

Step 7: Created a Certbot Configuration File
Created a configuration file in /etc/letsencrypt/renewal-hooks/deploy/ for  WordPress site.

Step 8: Obtain SSL Certificate
Run sudo certbot --nginx to obtain and configure SSL certificates for your domains.

Step 9: Automate Certificate Renewal
Created a cron job to run certbot renew periodically to renew SSL certificates.
Elasticache Memcached for PHP Session Management

Step 10: Set Up Elasticache Memcached
Created an Amazon Elasticache Memcached cluster for PHP session management.
Created 3 terraform files main.tf, outputs.tf and variables.tf
Configured the necessary security groups to allow traffic between the cluster and EKS.

Step 11: Configure PHP for Session Management
Configure PHP on  WordPress containers to use the Memcached server for session storage.
Update  wp-config.php file.


Step12. TERRAFORM MAIN FILE

main.tf

Mention AWS provider with a configure profile createdd using AWS CLI.

Use module "eks_module" to setup EKS Cluster and node group.
Use rds_module and pass the required variables using outputs of eks module for creation of RDS database.

Get the output host name of wordpress loadbalencer and open the URL using chrome browser.


RUNNING THE TERRAFORM FILES
Step 1: Run command "terraform init" to initialize the terraform, it will download all the required plugins.

Step 2: Validate the terraform files to check for syntax errors.

Step 3: Run command "terraform apply" to apply all changes and deploy
