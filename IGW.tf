//internetGateway

resource "aws_internet_gateway" "public_internetgateway_1"{

        vpc_id =   aws_vpc.main.id

tags={

    Name = "internet_gatway_1"
}

}


//public internet gateway 2
/*resource "aws_internet_gateway" "public_internetgateway_2"{

        vpc_id =   aws_vpc.main.id

tags={

    Name = "internet_gatway_2"
}

}*/


