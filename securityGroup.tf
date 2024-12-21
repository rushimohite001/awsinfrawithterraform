
//Security group for public

resource "aws_security_group" "allow_all_public" {
  name        = "allow_all_traffic"
  description = "Security group allowing all traffic"
  vpc_id      = aws_vpc.main.id # Replace with your VPC ID

  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]  # Allows traffic from any IPv4 address
    ipv6_cidr_blocks = ["::/0"]  # Allows traffic from any IPv6 address (if required)
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allows traffic to any IPv4 address
    ipv6_cidr_blocks = ["::/0"]  # Allows traffic to any IPv6 address (if required)
  }

  tags = {
    Name = "allow-all-traffic"
  }
}



# Security Group for Private Instances to Allow Internal Communication
/*resource "aws_security_group" "private_sg" {
  name        = "private-instance-sg"
  description = "Allow for all traffic"

  vpc_id = aws_vpc.main.id

  # Allow all traffic within the private subnet
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allows traffic to any IPv4 address
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow egress to the Internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
   tags = {
   Name = "private_sg"
 }
}*/



resource "aws_security_group" "private_sg" {
  name        = "allow_ssh"
  vpc_id       = aws_vpc.main.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with specific IPs for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
     tags = {
   Name = "private_sg"

}
}



