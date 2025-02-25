data "aws_eks_cluster" "eks" {
  name = "learning-kube-${local.env}"
}

data "tls_certificate" "eks" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  count = local.env == "stg" ? 1 : 0

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.eks.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.eks.url
}

resource "aws_eks_identity_provider_config" "eks" {
  count = local.env == "stg" ? 1 : 0

  cluster_name = data.aws_eks_cluster.eks.name

  oidc {
    client_id                     = substr(data.aws_eks_cluster.eks.identity.0.oidc.0.issuer, -32, -1)
    identity_provider_config_name = "oidc"
    issuer_url                    = "https://${aws_iam_openid_connect_provider.eks[count.index].url}"
  }
}
