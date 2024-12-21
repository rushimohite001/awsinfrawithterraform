// Security Group for Private Subnets (MySQL)
resource "aws_security_group" "private_sg_mysql" {
  name        = "private-sg-mysql"
  description = "Allow MySQL traffic between private subnets"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow MySQL traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Adjust to your private network CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Private Instances with MySQL
resource "aws_instance" "private_instance_mysql" {
  count                  = 2
  ami                    = var.golden_ami_id
  instance_type          = "t2.micro"
  subnet_id              = element([aws_subnet.private_subnet.id, aws_subnet.private_subnet_1.id], count.index)
  key_name               = aws_key_pair.loginkey.key_name
  vpc_security_group_ids = [aws_security_group.private_sg_mysql.id]

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/var/lib/jenkins/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "MySQL-Private-Instance-${count.index + 1}"
  }
}
