# Public Route Table 1
resource "aws_route_table" "public_rt_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Default route for internet access
    gateway_id = aws_internet_gateway.public_internetgateway_1.id
  }

  tags = {
    Name = "public-route-table-1"
  }
}

# Associate Route Table 1 with Public Subnet 1
resource "aws_route_table_association" "public_subnet_assoc_1" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt_1.id
}


# Public Route Table 2
/*resource "aws_route_table" "public_rt_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Default route for internet access
    gateway_id = aws_internet_gateway.public_internetgateway_1.id
  }

  tags = {
    Name = "public-route-table-2"
  }
}
*/

# Associate Route Table 2 with Public Subnet 2
resource "aws_route_table_association" "public_subnet_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt_1.id
}
