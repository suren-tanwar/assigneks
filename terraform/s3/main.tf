provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"

}

# main.tf

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket" # Replace with your bucket name
    key            = "my-eks-project/terraform.tfstate" # Set a unique key for your state file
    region         = "ap-south-1" # Replace with your region
    encrypt        = true
    dynamodb_table = "my-lock-table" # Optional: Add a DynamoDB lock table
  }
}


