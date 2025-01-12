output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.k8s.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.k8s.name
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.k8s.certificate_authority[0].data
}

