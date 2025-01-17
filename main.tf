provider "aws" {
  region = local.region
}

resource "aws_eks_cluster" "k8s" {
  name     = local.cluster_name
  role_arn = aws_iam_role.controlplanerole.arn

  vpc_config {
    subnet_ids = values(aws_subnet.public_subnet)[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.pol1,
    aws_iam_role_policy_attachment.pol2,
  ]
    #Change Auth Mode from Config to EKS API
    access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

#latest version of the Amazon EKS optimized Amazon Linux AMI for a given EKS version by querying an Amazon provided SSM parameter#
data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.k8s.version}/amazon-linux-2-gpu/recommended/release_version"
}

resource "aws_eks_node_group" "k8s-node" {
  cluster_name    = aws_eks_cluster.k8s.name
  node_group_name = "k8s-node"
  version         = aws_eks_cluster.k8s.version
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  node_role_arn   = aws_iam_role.workernode.arn
  subnet_ids      = values(aws_subnet.public_subnet)[*].id

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
    }
    
    instance_types = ["t2.medium"]
    capacity_type  = "SPOT"
  
    
  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "${local.environment}-${local.cluster_name}"
  }

  depends_on = [
    aws_iam_role_policy_attachment.pol3,
    aws_iam_role_policy_attachment.pol4,
    aws_iam_role_policy_attachment.pol5,
    aws_iam_role_policy_attachment.pol6,
  ]
}

# Retrieve EKS cluster details
data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.k8s.name

  depends_on = [aws_eks_cluster.k8s]
}

# Retrieve EKS cluster authentication details
data "aws_eks_cluster_auth" "ephemeral" {
  name = aws_eks_cluster.k8s.name

  depends_on = [aws_eks_cluster.k8s]
}




