output "rds_db_user" {
   value = aws_db_instance.rdsinstance.username
}

output "rds_db_name" {
   value = aws_db_instance.rdsinstance.db_name
}

output "rds_db_host" {
   value = aws_db_instance.rdsinstance.address
}

output "rds_db_pass" {
   value = aws_db_instance.rdsinstance.password
}

output "rds_endpoint" {
  value = aws_db_instance.rdsinstance.endpoint
}