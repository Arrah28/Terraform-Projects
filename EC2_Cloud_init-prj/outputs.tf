output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.cloud_init_Server.id
}

output "instance_type" {
  description = "Type of the EC2 instance"
  value       = aws_instance.cloud_init_Server.instance_type
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.cloud_init_Server.public_ip
}

output "instance_availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.cloud_init_Server.availability_zone
}
