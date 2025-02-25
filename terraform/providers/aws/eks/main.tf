locals {
  env = terraform.workspace
}

// Get subnet ids data from AWS
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.terraform_remote_state.vpc.outputs.vpc_id]
  }

  // Filter EKS subnets only
  filter {
    name   = "tag:Product"
    values = [
      "${var.product} - Subnet EKS private",
      "${var.product} - Subnet EKS public"
    ]
  }
}

// Get private subnet ids from AWS
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.terraform_remote_state.vpc.outputs.vpc_id]
  }

  // Filter EKS subnets only
  filter {
    name   = "tag:Product"
    values = [
      "${var.product} - Subnet EKS private"
    ]
  }
}