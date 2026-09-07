variable "AmiId" {
  type        = string
  default     = "ami-081b0a6eac00b4f53"
  description = "The AMI ID to use for the EC2 instance."
}

variable "InstanceType" {
  type        = string
  description = "The type of instance to use for the server."
}


variable "SecurityGroupName" {
  type        = string
  description = "The name of the security group to create."
}



