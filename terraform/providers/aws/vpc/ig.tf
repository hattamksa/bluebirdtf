// Internet gw
resource "aws_internet_gateway" "gw" {
  count = local.env == "stg" ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Organization = var.organization
    Product      = "${var.product} - IG"
    Division     = var.division
    Name         = "Eccomerce main-ig ${local.env}"
    Environment  = local.env
  }
}

// Route table public subnets
resource "aws_route_table" "public" {
  count = 1

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.gw[count.index].id
  }


  tags = {
    Organization = var.organization
    Product      = "${var.product} - public RT"
    Division     = var.division
    Name         = "eccomerce public-rt ${local.env}"
    Environment  = local.env
  }
}



// Route table association public subnets
resource "aws_route_table_association" "public" {
  count = local.env == "stg" ? length(var.public_subnet_cidrs[local.env]) : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}
 