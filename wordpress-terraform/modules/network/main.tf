resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-vpc"
    Owner = var.owner
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name_prefix}-igw", Owner = var.owner })
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "${var.name_prefix}-public-${count.index + 1}", Owner = var.owner })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, { Name = "${var.name_prefix}-private-${count.index + 1}", Owner = var.owner })
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(var.tags, { Name = "${var.name_prefix}-nat-eip", Owner = var.owner })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [
    aws_internet_gateway.this,  # reference the whole resource
    aws_eip.nat  # reference the whole resource
  ]

  tags = merge(var.tags, { Name = "${var.name_prefix}-nat", Owner = var.owner })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-public-rt", Owner = var.owner })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-private-rt", Owner = var.owner })
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# SG: ALB
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "ALB ingress from internet"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-alb-sg", Owner = var.owner })
}

# SG: WEB
resource "aws_security_group" "web" {
  name        = "${var.name_prefix}-web-sg"
  description = "Allow HTTP from ALB only"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = var.http_port
    to_port         = var.http_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port   = var.node_exporter_port
    to_port     = var.node_exporter_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
    description = "Allow Prometheus scrape"
  }

  ingress {
    from_port   = var.grafana_port
    to_port     = var.grafana_port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
    description = "Allow Grafana access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-web-sg", Owner = var.owner })
}

# SG: MYSQL
resource "aws_security_group" "mysql" {
  name        = "${var.name_prefix}-mysql-sg"
  description = "Allow MySQL from web servers only"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = var.mysql_port
    to_port         = var.mysql_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-mysql-sg", Owner = var.owner })
}

# SG: EFS
resource "aws_security_group" "efs" {
  name        = "${var.name_prefix}-efs-sg"
  description = "Allow NFS from web instances only"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = var.nfs_port
    to_port         = var.nfs_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-efs-sg", Owner = var.owner })
}
