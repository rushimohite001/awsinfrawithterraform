resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "NATGatewayEIP_1"
  }
}

//create NAT gateway for private subnet_1
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "NatGateway_1"
  }
}

//elastic IP for second NAT Gateway
/*resource "aws_eip" "nat_eip_2" {
 vpc = true
 tags = {
   Name = "NATGatewayEIP_2"
 }
}*/


//create NAT gateway for private subnet_2
/*resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "NatGateway_2"
  }
}
*/


///Create private route table for publicsubnet 1
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "PrivateRouteTable_1"
  }
}


///Create private route table for publicsubnet 2
/*resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id
  tags = {
  Name = "PrivateRouteTable_2"
}
}
*/


//Associate nategateway to route table for private 1 subnet
resource "aws_route" "private_route_1" {
  route_table_id         = aws_route_table.private_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
}


//Add subnet to private route table for private subnet 1
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_1.id
}


//Associate nategateway to route table for private 2 subnet
/*resource "aws_route" "private_route_2" {
  route_table_id         = aws_route_table.private_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_2.id
}
*/

//Add subnet to private route table for private subnet 2
resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_1.id
}






  
