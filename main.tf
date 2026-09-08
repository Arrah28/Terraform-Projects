# 1. Dynamically fetch the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}


# 2. Creates a Security Group to allow HTTP (Port 80) and SSH (Port 22)
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Launches the EC2 Instance with Cloud-init and the Security Group attached
resource "aws_instance" "cloud_init_Server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.InstanceType
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Cloud-init script runs automatically on first boot
  user_data = file("${path.module}/cloud-init.yaml")
  tags = {
    Name = "CloudInit-Server"
  }
}