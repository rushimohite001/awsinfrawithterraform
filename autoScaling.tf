resource "aws_autoscaling_group" "public_asg" {
  launch_template {
    id = aws_launch_template.public_launch_template.id
    //version = "$Latest"
  }

  min_size         = 1
  max_size         = 5
  desired_capacity = 2

  vpc_zone_identifier = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_1.id]


  tag {
    key                 = "Name"
    value               = "Public-ASG"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_group" "private_asg" {
  launch_template {
    id = aws_launch_template.private_launch_template.id
    //version = "$Latest"
  }

  min_size         = 1
  max_size         = 5
  desired_capacity = 2

  vpc_zone_identifier = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_1.id]

  tag {
    key                 = "Name"
    value               = "Private-ASG"
    propagate_at_launch = true
  }

}
