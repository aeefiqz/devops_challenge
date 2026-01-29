module "eks"  {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name             = var.cluster_name
  cluster_version          = var.eks_version
  vpc_id                   = module.eks-vpc.vpc_id
  subnet_ids               = concat(module.eks-vpc.public_subnets, module.eks-vpc.private_subnets)
  control_plane_subnet_ids = module.eks-vpc.private_subnets
  
  authentication_mode = "API"
  enable_cluster_creator_admin_permissions = true
  bootstrap_self_managed_addons = true
  
  create_cloudwatch_log_group = true
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  create_iam_role = true
  create_cluster_security_group = true
  enable_security_groups_for_pods = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  
  enable_irsa = true
  attach_cluster_encryption_policy = false
  create_node_security_group = false
 

  eks_managed_node_groups = {
    general = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      labels = {
        role = "general"
      }
    }
    spot = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
      labels = {
        role = "spot"
      }
    }
  }
  depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]

  tags = merge(var.tags, {
    Name        = var.cluster_name
    Environment = var.environment
  })
}

