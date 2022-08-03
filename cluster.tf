resource "aws_eks_cluster" "cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eksrole.arn
  version  = var.eks-version
  vpc_config {
    subnet_ids = [aws_subnet.subnet_id_1.id, aws_subnet.subnet_id_2.id, aws_subnet.subnet_id_3.id, aws_subnet.subnet_id_4.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
  tags = {
    Name = "${local.tag}-eks"
  }
}

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