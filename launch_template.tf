resource "aws_launch_template" "public_launch_template" {
  name_prefix   = "public-instance-template"
  image_id      = aws_ami_from_instance.public_instance_ami[0].id  # create AMI id for create templte
  instance_type = "t2.micro" # Adjust based on your instance type requirements

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Public-Template-Instance"
    }
  }
}

resource "aws_launch_template" "private_launch_template" {
  name_prefix   = "private-instance-template"
  image_id      = aws_ami_from_instance.private_instance_ami[0].id  # create AMI id for create templte
  instance_type = "t2.micro"

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Private-ASGTemplate-Instance"
    }
  }
}
