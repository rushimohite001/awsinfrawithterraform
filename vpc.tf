//VPC Creation

resource "aws_vpc" "main" {
  cidr_block       = local.vpc_cidr_block
 

  tags = {
    Name = local.vpc_tag_name
  }
}

