//public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = local.public_subnet_cidr
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

    tags = {
      Name = local.public_subnet_tag_name
    }
  
}

//private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = local.private_subnet_cidr
    availability_zone = "us-east-1a"
    tags = {
      Name = local.private_subnet_tag_name
    }
  
}


//public subnet for second public subnet
resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = local.public_subnet_cidr_1
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
    tags = {
      Name = local.public_subnet_tag_name_1
    }
  
}

//private subnet
resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = local.private_subnet_cidr_2
    availability_zone = "us-east-1b"
    tags = {
      Name = local.private_subnet_tag_name_2
    }
  
}