resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "eks-vpc"
  }
}

  resource "aws_subnet" "public_subnet_1" {
  count = 2
  cidr_block = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone = element(["ap-south-1a", "ap-south-1b"], count.index)
  vpc_id = aws_vpc.eks_vpc.id
}


resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
   Name = "int_gw"
     }
    }

#Create a ROUTE TABLE FOR PUBLIC SUBNET

resource "aws_route_table" "public_route_table" {
   vpc_id = aws_vpc.eks_vpc.id
   route {
    cidr_block= "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
     }
}

# Create a route for Internet Gateway
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gw.id
}
