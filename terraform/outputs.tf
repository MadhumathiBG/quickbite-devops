output "devops_public_ip" {
  description = "Public IP of DevOps Control Node"
  value       = aws_instance.devops_control.public_ip
}

output "app_public_ip" {
  description = "Public IP of Application Server"
  value       = aws_instance.application_server.public_ip
}

output "db_private_ip" {
  description = "Private IP of Database Server"
  value       = aws_instance.database_server.private_ip
}
