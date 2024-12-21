variable "golden_ami_id" {
  description = "AMI ID for the golden image"
}

//create existing AMI server 
data "aws_ami" "app_ami" {
  owners      = ["amazon"]
  most_recent = true


  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10**"]
  }
}
//key-Pair Value
resource "aws_key_pair" "loginkey" {
  key_name   = "myvirkey_2"
  public_key = file("/var/lib/jenkins/.ssh/id_rsa.pub")
}

//Add a Delay Before Provisioning
resource "time_sleep" "wait_for_instance" {
  depends_on = [aws_instance.public_instance]
  create_duration = "30s" # Adjust as needed
}


resource "aws_instance" "public_instance" {
  count         = 2
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"
  subnet_id     = element([aws_subnet.public_subnet.id, aws_subnet.public_subnet_1.id], count.index)
  key_name      = aws_key_pair.loginkey.key_name
  vpc_security_group_ids = [aws_security_group.allow_all_public.id]

 provisioner "remote-exec" {
  inline = [
    "sudo yum update -y",
    "sudo yum install httpd -y",
    "sudo systemctl enable httpd",
    "sudo systemctl start httpd"
  ]
    when = create
}
connection {
  type        = "ssh"
  user        = "ec2-user"
  private_key = file("id_ed25519")
  host        = self.public_ip
  timeout     = "5m" # Increase timeout as needed
  bastion_host = aws_instance.public_instance[0].public_ip
}

  tags = {
    Name = "Public-Instance-${count.index + 1}"
  }
}


//create golden image for private instance
resource "aws_instance" "private_instance" {
  count         = 2
  ami           = var.golden_ami_id
  instance_type = "t2.micro"
  subnet_id     = element([aws_subnet.private_subnet.id, aws_subnet.private_subnet_1.id], count.index)
  key_name      = aws_key_pair.loginkey.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  provisioner "remote-exec" {
    inline = [
      "sleep 60", # Wait for the instance to initialize
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd"
    ]
    when = create
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("id_ed25519")
    host        = self.private_ip
    #baston is added for private server because private ,The bastion acts as an intermediary (jump box) to access resources in private networks via SSH.
    bastion_host = aws_instance.public_instance[0].public_ip
    bastion_user = "ec2-user"
    bastion_private_key = file("id_ed25519")
    timeout     = "5m"
  }

  tags = {
    Name = "Private-Instance-${count.index + 1}"
  }
}
