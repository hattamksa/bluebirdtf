// AWS EKS cluster
resource "aws_eks_cluster" "eks" {
  count = local.env == "stg" ? 1 : 0

  name     = "learning-kube-${local.env}"
  role_arn = aws_iam_role.eks_cluster[count.index].arn
  version  = var.k8s_version[local.env]

  vpc_config {
    subnet_ids = data.aws_subnets.all.ids
  }

  tags = {
    Organization = var.organization
    Product      = "${var.product} - EKS cluster"
    Division     = var.division
    Name         = "learning EKS cluster ${local.env}"
    Environment  = local.env
  }

  depends_on = [
    aws_iam_role.eks_cluster,
  ]
}
