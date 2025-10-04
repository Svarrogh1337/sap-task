resource "aws_vpc" "infra" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}
resource "aws_subnet" "db" {
  count = var.deploy_db ? 2 : 0
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index+250)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.infra.id

  tags = {
    Name = "${var.project_name}-db-subnet"
  }
}
resource "aws_db_subnet_group" "db-subnet" {
  name       = "db subnet group"
  subnet_ids = aws_subnet.private.*.id
}
resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.infra.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.infra.id

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = cidrsubnet(aws_vpc.infra.cidr_block, 8, count.index + 2)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.infra.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_eip" "nat_gateway" {
  count = 2
  tags = {
    Name = "${var.project_name}-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = 2
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat_gateway[count.index].id

  tags = {
    Name = "${var.project_name}-nat-gw-${count.index}"
  }
}
resource "aws_default_security_group" "infra" {
  vpc_id = aws_vpc.infra.id

  ingress {
    description = "Allow HTTP inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS inbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-scg"
  }
}
########################################################################################################################
## Route to the internet using the NAT Gateway
########################################################################################################################

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.infra.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name     = "${var.project_name}-private-rt-${count.index}"
  }
}

########################################################################################################################
## Associate Route Table with Private Subnets
########################################################################################################################

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}