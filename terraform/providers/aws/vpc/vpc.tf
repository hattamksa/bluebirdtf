resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr[local.env]
  instance_tenancy = "default"

  tags = {
    Organization = var.organization
    Product      = "${var.product} - VPC"
    Division     = var.division
    Name         = "learning main-vpc ${local.env}"
    Environment  = local.env
  }
} 
