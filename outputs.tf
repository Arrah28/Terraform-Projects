output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.wordpress.id
}

output "instance_type" {
  description = "Type of the EC2 instance"
  value       = aws_instance.wordpress.instance_type
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.wordpress.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.wordpress.private_ip
}

output "instance_availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.wordpress.availability_zone
}