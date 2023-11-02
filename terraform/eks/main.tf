module "vpc" {
  source = "../vpc"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids         = module.vpc.public_subnets
    security_group_ids = [aws_security_group.eks_sg.id]

  }
  version = "1.27"
  
}

# cluster role
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com",
        },
      },
    ],
  })
}

# cluster policy
resource "aws_iam_policy" "eks_cluster_policy" {
  name        = "eks-cluster-policy"
  description = "IAM policy for EKS cluster"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "eks:DescribeCluster",
        Effect   = "Allow",
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluste_service_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


resource "aws_security_group" "eks_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for the EKS cluster"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_eks_node_group" "node_group" { 
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "wp_ng"
  node_role_arn   = aws_iam_role.eks_cluster_role.name
  subnet_ids      = module.vpc.public_subnets
  remote_access {
      ec2_ssh_key =  "webkey"
   }
  instance_types = ["t2.micro"]
  scaling_config {
      desired_size = 2
      max_size = 2
      min_size = 1
   }
   tags = {
   "role" = "eks nodes"
  }

}

