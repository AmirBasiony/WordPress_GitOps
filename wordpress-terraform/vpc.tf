
###############################
#           VPC              #
###############################
resource "aws_vpc" "AppVPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name  = "amir-wp-vpc"
    Owner = "amir"
  }
}

resource "aws_internet_gateway" "AppInternetGateway" {
  vpc_id = aws_vpc.AppVPC.id

  tags = {
  Name  = "amir-wp-igw"
  Owner = "amir"
  }
}

###############################
#         SUBNETS            #
###############################
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.AppVPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
  Name  = "amir-wp-public-subnet-1"
  Owner = "amir"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.AppVPC.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name  = "amir-wp-public-subnet-2"
    Owner = "amir"
  }

}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.AppVPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name  = "amir-wp-private-subnet-1"
    Owner = "amir"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.AppVPC.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name  = "amir-wp-private-subnet-2"
    Owner = "amir"
  }
}

###############################
#     NAT & EIP for NAT      #
###############################
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  
  tags = {
    Name  = "amir-wp-nat-eip"
    Owner = "amir"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_internet_gateway.AppInternetGateway]

  tags = {
    Name  = "amir-wp-nat"
    Owner = "amir"
  }
}

###############################
#      SECURITY GROUPS       #
###############################
resource "aws_security_group" "alb_sg" {
  name        = "amir-wp-alb-sg"
  description = "ALB ingress from internet"
  vpc_id      = aws_vpc.AppVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "amir-wp-alb-sg"
    Owner = "amir"
  }
}


resource "aws_security_group" "web_sg" {
  name        = "amir-wp-web-sg"
  description = "Allow HTTP from ALB only"
  vpc_id      = aws_vpc.AppVPC.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.AppVPC.cidr_block]
    description     = "Allow Prometheus to scrape node_exporter"
  }  

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.AppVPC.cidr_block]
    description     = "Allow Grafana access for monitoring host"
  } 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "amir-wp-web-sg"
    Owner = "amir"
  }
}



resource "aws_security_group" "mysql_sg" {
  name        = "amir-wp-mysql-sg"
  description = "Allow MySQL from web servers only"
  vpc_id      = aws_vpc.AppVPC.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "amir-wp-mysql-sg"
    Owner = "amir"
  }
}
  
resource "aws_security_group" "efs_sg" {
  name        = "amir-wp-efs-sg"
  description = "Allow NFS from app/web instances only"
  vpc_id      = aws_vpc.AppVPC.id

  ingress {
    description     = "NFS from app SG"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "amir-wp-efs-sg"
    Owner = "amir"
  }
}
