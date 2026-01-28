module "vpc" {
  source = "./modules/vpc"

  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnets        = var.public_subnets
  private_subnets       = var.private_subnets
  public_subnets_count  = var.public_subnets_count
  private_subnets_count = var.private_subnets_count
  cluster_name          = var.cluster_name

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_vpc_flow_logs = var.enable_vpc_flow_logs
  tags                 = var.tags
}

module "eks" {
  source = "./modules/eks"

  environment  = var.environment
  cluster_name = var.cluster_name
  eks_version  = var.eks_version

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnet_ids
  control_plane_subnet_ids = module.vpc.private_subnet_ids

  tags = var.tags

  depends_on = [module.vpc]
}

module "securitygroup" {
  source = "./modules/securitygroup"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id

  depends_on = [module.vpc]
}
