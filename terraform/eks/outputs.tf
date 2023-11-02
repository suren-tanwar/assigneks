output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "node_groupname" {
  description = "Node Group of the EKS cluster"
  value       = aws_eks_node_group.node_group.node_group_name
}
