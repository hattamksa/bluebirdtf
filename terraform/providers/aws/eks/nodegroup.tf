
// AWS EKS Nodegroup for REST and Istio
resource "aws_eks_node_group" "ng_rest" {
  count = local.env == "stg" ? 1 : 0

  cluster_name    = aws_eks_cluster.eks[count.index].name
  node_group_name = "ng_rest"
  node_role_arn   = aws_iam_role.eks_nodes[count.index].arn
  subnet_ids      = data.aws_subnets.private.ids
  instance_types  = [var.ng_rest_instance_type[local.env]]

  scaling_config {
    desired_size = 1
    min_size     = 0
    max_size     = 1
  }

  dynamic "taint" {
    for_each = var.rest_taints
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  tags = {
    Organization = var.organization
    Product      = "${var.product} - EKS nodegroup"
    Division     = var.division
    Name         = "eccomerce EKS nodegroup ${local.env}"
    Environment  = local.env
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_iam_worker_node_policy,
    aws_iam_role_policy_attachment.eks_iam_cni_policy,
    aws_iam_role_policy_attachment.eks_iam_container_registry_policy,
  ]
}


