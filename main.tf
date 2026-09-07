# 1. Creates a Security Group to allow HTTP (Port 80) and SSH (Port 22)
resource "aws_security_group" "web_sg" {
  name        = var.SecurityGroupName
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

# 2. Launches the EC2 Instance with User Data and the Security Group attached
resource "aws_instance" "wordpress" {
  ami                    = var.AmiId
  instance_type          = var.InstanceType
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # User data script runs automatically on first boot
  user_data = <<-EOF
#!/bin/bash

exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1

echo "===== User data started ====="

# 1. Update system and install packages
dnf update -y
dnf install -y httpd wget php php-mysqlnd mariadb105-server firewalld

# 2. Start and enable services
systemctl enable --now firewalld
systemctl enable --now httpd
systemctl enable --now mariadb

# 3. Configure firewall
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

# 4. Wait for MariaDB to be ready
echo "Waiting for MariaDB..."

for i in {1..30}; do
    if mysqladmin ping -u root --silent; then
        echo "MariaDB is ready."
        break
    fi

    echo "MariaDB not ready yet. Waiting..."
    sleep 2
done

# 5. Setup database
mysql -u root -e "CREATE DATABASE IF NOT EXISTS wordpress;"

mysql -u root -e "CREATE USER IF NOT EXISTS 'wordpress-user'@'localhost' IDENTIFIED BY 'StrongPassword123!';"

mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress-user'@'localhost';"

mysql -u root -e "FLUSH PRIVILEGES;"

# 6. Download and extract WordPress
cd /var/www/html

echo "Downloading WordPress..."
wget -O latest.tar.gz https://wordpress.org/latest.tar.gz

echo "Extracting WordPress..."
tar -xzf latest.tar.gz

echo "Copying WordPress files..."
cp -r wordpress/* /var/www/html/

# 7. Clean up
rm -rf wordpress latest.tar.gz

# 8. Set permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# 9. Restart Apache
systemctl restart httpd

echo "===== User data completed successfully ====="
EOF
  tags = {
    Name = "WordPress-Server"
  }
}