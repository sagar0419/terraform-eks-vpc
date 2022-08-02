resource "aws_eks_cluster" "cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eksrole.arn
  version  = var.eks-version
  vpc_config {
    subnet_ids = [aws_subnet.subnet_id_1.id, aws_subnet.subnet_id_2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
  tags = {
    Name = "${local.tag}-eks"
  }
}

/*
##Enabeling  IAM role for service account

data "tls_certificate" "eks_tls" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_iam" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_iam.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_iam.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "serviceaccount" {
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
  name               = "serviceaccount"
}

*/

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "config-map-aws-auth" {
  value = local.config-map-aws-auth
}

output "kubeconfig" {
  value = local.kubeconfig
}
