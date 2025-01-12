
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.53.0"
      
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"

  host                   = data.aws_eks_cluster.k8s.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.k8s.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.k8s.token
}
