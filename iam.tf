#IAM Role#
resource "aws_iam_role" "controlplanerole" {
  name               = "${local.environment}-${local.cluster_name}-controlplanerole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role1.json
}

data "aws_iam_policy_document" "assume_role1" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#Policy attachments for EKS Cluster#
resource "aws_iam_role_policy_attachment" "pol1" {
  role       = aws_iam_role.controlplanerole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "pol2" {
  role       = aws_iam_role.controlplanerole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

#IAM Role for managed group#
resource "aws_iam_role" "workernode" {
  name               = "${local.environment}-${local.cluster_name}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role2.json
}

data "aws_iam_policy_document" "assume_role2" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#Policy attachments for managed nodes#
resource "aws_iam_role_policy_attachment" "pol3" {
  role       = aws_iam_role.workernode.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "pol4" {
  role       = aws_iam_role.workernode.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "pol5" {
  role       = aws_iam_role.workernode.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "pol6" {
  role       = aws_iam_role.workernode.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#Create EKS Access Entry

#IAM Role#
resource "aws_iam_role" "eksadmin" {
  name               = "${local.environment}-${local.cluster_name}-eksadmin"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.eks-admin.json
}

# Retrieve current AWS account ID
data "aws_caller_identity" "current" {}


#Document for AWS Users
data "aws_iam_policy_document" "eks-admin" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = ["sts:AssumeRole"]
  }
}


##Map Current Users to EKS Admin Permission 

resource "aws_eks_access_entry" "eks-admin" {
  cluster_name      = local.cluster_name
  principal_arn     = aws_iam_role.eksadmin.arn
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "eksClusterAccess" {
  cluster_name  = local.cluster_name
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = aws_iam_role.eksadmin.arn

  access_scope {
    type = "cluster"
  }
}