// Nat gw ip allocation
resource "aws_eip" "nat_ip" {
  count = local.env == "stg" ? 1 : 0

  vpc = true
}

// Nat gw for private subnets
resource "aws_nat_gateway" "nat_gw" {
  count = local.env == "stg" ? 1 : 0

  allocation_id = aws_eip.nat_ip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Organization = var.organization
    Product      = "${var.product} - NAT GW"
    Division     = var.division
    Name         = "learning main-nat ${local.env}"
    Environment  = local.env
  }
}

// Route table private subnets
resource "aws_route_table" "private" {
  count = local.env == "stg" ? 1 : 0

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }


  tags = {
    Organization = var.organization
    Product      = "${var.product} - private RT"
    Division     = var.division
    Name         = "bluebird private-rt ${local.env}"
    Environment  = local.env
  }
}

// Route table association private subnets
resource "aws_route_table_association" "private" {
  count = local.env == "stg" ? length(var.private_subnet_cidrs[local.env]) : 0

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private[0].id
}
