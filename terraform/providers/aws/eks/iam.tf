# --------------------------------------------------------------------------
#  IAM Roles
# --------------------------------------------------------------------------
resource "aws_iam_role" "eks_cluster" {
  count = local.env == "stg" ? 1 : 0

  name = "eks-role-cluster-${local.env}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_service_role_attachment" {
  count      = local.env == "stg" ? 1 : 0
  role       = aws_iam_role.eks_cluster[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "eks_iam_cluster_policy" {
  count = local.env == "stg" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks_iam_service_policy" {
  count = local.env == "stg" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks_iam_registry" {
  count = local.env == "stg" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster[count.index].name
}

resource "aws_iam_role" "eks_nodes" {
  count = local.env == "stg" ? 1 : 0

  name = "eks-role-nodes-${local.env}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
#============ connecting volume dilevel iam node group ================#
resource "aws_iam_role_policy_attachment" "ec2_full_access_attachment" {
  count = local.env == "stg" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.eks_nodes[count.index].name
}
#============batas connecting volume ebs dilevel iam node group ================#
resource "aws_iam_role_policy_attachment" "eks_iam_worker_node_policy" {
  count = local.env == "stg" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks_iam_cni_policy" {
  count = local.env == "stg" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes[count.index].name
}

resource "aws_iam_role_policy_attachment" "eks_iam_container_registry_policy" {
  count = local.env == "stg" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes[count.index].name
}

// IAM for cert-manager
resource "aws_iam_policy" "letsencrypt_policy" {
  count = local.env == "stg" ? 1 : 0

  name   = "letsencrypt-${local.env}"
  policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [{
			"Action": "route53:GetChange",
			"Effect": "Allow",
			"Resource": "arn:aws:route53:::change/*"
		},
		{
			"Action": [
				"route53:ChangeResourceRecordSets",
				"route53:ListResourceRecordSets"
			],
			"Effect": "Allow",
			"Resource": [
        "arn:aws:route53:::hostedzone/{see route53}"
      ]
		}
	]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "letsencrypt_policy" {
  count = local.env == "stg" ? 1 : 0

  policy_arn = aws_iam_policy.letsencrypt_policy[count.index].arn
  role       = aws_iam_role.eks_nodes[count.index].name
}

// IAM for autoscaler
resource "aws_iam_policy" "autoscaler_policy" {
  count = local.env == "stg" ? 1 : 0

  name   = "autoscaler-${local.env}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeImages",
        "ec2:GetInstanceTypesFromInstanceRequirements",
        "eks:DescribeNodegroup"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
            "aws:ResourceTag/k8s.io/cluster-autoscaler/${aws_eks_cluster.eks[count.index].name}": "owned"
        }
      }
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeAutoScalingGroups",
        "ec2:DescribeLaunchTemplateVersions",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:DescribeLaunchConfigurations",
        "ec2:DescribeInstanceTypes"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

data "aws_iam_policy_document" "open_trust_connect" {
  count = local.env == "stg" ? 1 : 0
  statement {
    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.eks[count.index].arn
      ]
    }
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.eks[count.index].url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.sa_autoscaler_namespace}:${var.sa_autoscaler_name}"
      ]
    }
  }
}
##========= access storage s3===============================#
data "aws_iam_policy_document" "access_storage_trust" {
  count = local.env == "stg" ? 1 : 0
  statement {
    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.eks[count.index].arn
      ]
    }
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.eks[count.index].url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.sa_storage_s3_namespace}:${var.sa_storage_s3_name}"
      ]
    }
  }
}
# attach to role access storage s3
resource "aws_iam_role_policy_attachment" "storage_bucket_permission" {
  count = local.env == "stg" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.access_bucket[count.index].name
}
##=========  access storage s3===============================#
resource "aws_iam_role" "access_bucket" {
  count = local.env == "stg" ? 1 : 0

  name               = "node-access-${local.env}"
  assume_role_policy = data.aws_iam_policy_document.access_storage_trust[count.index].json
}

resource "aws_iam_role" "autoscaler" {
  count = local.env == "stg" ? 1 : 0

  name               = "node-autoscaler-${local.env}"
  assume_role_policy = data.aws_iam_policy_document.open_trust_connect[count.index].json
}

resource "aws_iam_role_policy_attachment" "autoscaler" {
  count = local.env == "stg" ? 1 : 0

  role       = aws_iam_role.autoscaler[count.index].name
  policy_arn = aws_iam_policy.autoscaler_policy[count.index].arn
}
