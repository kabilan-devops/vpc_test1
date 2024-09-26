resource "aws_vpc" "test_vpc" {
  cidr_block = var.block1
  tags = {
    Name = var.vpcname
  }
}
resource "aws_subnet" "publicsub1"{
  vpc_id=aws_vpc.test_vpc.id
  cidr_block=var.block2
  availability_zone="us-west-2a"
  map_public_ip_on_launch=true
  tags = {
    Name=var.publicsub1
  }
}
resource "aws_subnet" "publicsub2"{
  vpc_id=aws_vpc.test_vpc.id
  cidr_block=var.block3
  availability_zone="us-west-2b"
  map_public_ip_on_launch=true
  tags={
    Name=var.publicsub2
  }
}
resource "aws_internet_gateway" "test_igw"{
  vpc_id=aws_vpc.test_vpc.id

}
resource "aws_route_table" "pubrt"{
  vpc_id = aws_vpc.test_vpc.id

  route{#linking route table and igw
    cidr_block=var.block4 #allowing all ips
    gateway_id=aws_internet_gateway.test_igw.id #attaching internet gateway to vpc
  }
}
resource "aws_route_table_association" "routeassoc1"{#to get internet connection for public machines
  route_table_id = aws_route_table.pubrt.id
  subnet_id=aws_subnet.publicsub1.id
}
resource "aws_route_table_association" "routeassoc2"{
  route_table_id=aws_route_table.pubrt.id
  subnet_id = aws_subnet.publicsub2.id

}


