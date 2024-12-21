# Define a variable for AMI names
variable "ami_name_prefix" {
  description = "Prefix for AMI names"
  default     = "my-custom-ami"
}

# Key Pair Resource
resource "aws_key_pair" "default" {
  key_name   = "my-key"
  public_key = file("/var/lib/jenkins/.ssh/id_rsa.pub") # Path to your public key
}

# Create EC2 Instances (Public and Private)
resource "aws_instance" "public_instance" {
  count         = 2
  ami           = "ami-01816d07b1128cd2d" # Example AMI ID, replace with your region's AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.default.key_name
  tags = {
    Name = "Public-Instance-${count.index + 1}"
  }
}

resource "aws_instance" "private_instance" {
  count         = 2
  ami           = "ami-01816d07b1128cd2d" # Example AMI ID, replace with your region's AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.default.key_name
  tags = {
    Name = "Private-Instance-${count.index + 1}"
  }
}

# Create AMI from Public Instances
resource "aws_ami_from_instance" "public_instance_ami" {
  count              = 2
  source_instance_id = aws_instance.public_instance[count.index].id
  name               = "${var.ami_name_prefix}-public-${count.index + 1}"
  description        = "AMI created from Public Instance ${count.index + 1}"
  tags = {
    Name = "Public-AMI-${count.index + 1}"
  }
  depends_on = [aws_instance.public_instance]
}

# Stop Public Instances after AMI creation
resource "null_resource" "stop_public_instances" {
  count      = 2
  depends_on = [aws_ami_from_instance.public_instance_ami]

  connection {
    type        = "ssh"
    user        = "ec2-user" # Adjust if using a different AMI (e.g., ubuntu for Ubuntu AMIs)
    private_key = file("/var/lib/jenkins/.ssh/id_rsa") # Path to your private key
    host        = aws_instance.public_instance[count.index].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "aws ec2 stop-instances --instance-ids ${aws_instance.public_instance[count.index].id} --region us-east-1"
    ]
  }
}

# Create AMI from Private Instances
resource "aws_ami_from_instance" "private_instance_ami" {
  count              = 2
  source_instance_id = aws_instance.private_instance[count.index].id
  name               = "${var.ami_name_prefix}-private-${count.index + 1}"
  description        = "AMI created from Private Instance ${count.index + 1}"
  tags = {
    Name = "Private-AMI-${count.index + 1}"
  }
  depends_on = [aws_instance.private_instance]
}

# Stop Private Instances after AMI creation
resource "null_resource" "stop_private_instances" {
  count      = 2
  depends_on = [aws_ami_from_instance.private_instance_ami]

  connection {
    type        = "ssh"
    user        = "ec2-user" # Adjust if using a different AMI (e.g., ubuntu for Ubuntu AMIs)
    private_key = file("/var/lib/jenkins/.ssh/id_rsa") # Path to your private key
    host        = aws_instance.private_instance[count.index].private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "aws ec2 stop-instances --instance-ids ${aws_instance.private_instance[count.index].id} --region us-east-1"
    ]
  }
}
