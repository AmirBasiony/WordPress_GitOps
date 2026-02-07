###############################
#        ROUTE TABLES        #
###############################

# Public Route Table -> Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.AppVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AppInternetGateway.id
  }

  tags = {
    Name  = "amir-wp-public-rt"
    Owner = "amir"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_assoc" {
  for_each = local.public_subnet_ids

  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table -> NAT Gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.AppVPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name  = "amir-wp-private-rt"
    Owner = "amir"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_assoc" {
  for_each = local.private_subnet_ids

  subnet_id      = each.value
  route_table_id = aws_route_table.private_rt.id
}
