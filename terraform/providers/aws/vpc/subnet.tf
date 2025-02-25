resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs[local.env])
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs[local.env], count.index)
  availability_zone = element(var.subnet_azs, count.index)

  tags = {
    Organization = var.organization
    Product      = "${var.product} - Subnet EKS public"
    Division     = var.division
    Name         = "learning Public Subnet EKS ${local.env} ${count.index + 1}"
    Environment  = local.env
  }

  depends_on = [aws_vpc.main]
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs[local.env])
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs[local.env], count.index)
  availability_zone = element(var.subnet_azs, count.index)

  tags = {
    Organization = var.organization
    Product      = "${var.product} - Subnet EKS private"
    Division     = var.division
    Name         = "learning Private Subnet EKS ${local.env} ${count.index + 1}"
    Environment  = local.env

    // Needed for istio internal gateway
    "kubernetes.io/role/internal-elb" = "1"
  }

  depends_on = [aws_vpc.main]
}


