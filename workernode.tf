resource "aws_eks_node_group" "eks-worker" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.nodegroup-name
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = [aws_subnet.subnet_id_3.id, aws_subnet.subnet_id_4.id]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
  instance_types = var.node_instance_type
  ami_type       = var.ami_type
  capacity_type  = var.capacity_type
  disk_size      = var.disk_size

  update_config {
    max_unavailable = var.max_unavailable
  }

  depends_on = [
    aws_eks_cluster.cluster,
    aws_iam_role_policy_attachment.worker-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.worker-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.worker-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name = "${local.tag}-eks"
  }
}