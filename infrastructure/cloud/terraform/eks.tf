module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  # Networking
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Cluster access
  enable_cluster_creator_admin_permissions = true

  cluster_endpoint_public_access = true

  # Node Groups
  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 2
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      # EBS CSI Driver policy for persistent volume management
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  # EBS CSI Driver addon for persistent volumes
  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  # OIDC for IAM Roles for Service Accounts (IRSA)
  enable_irsa = true

  # Allow all inter-node communication
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "datavisyn-challenge"
  }
}

