module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.21"
  name    = "${var.environment}-vpc"
  cidr    = var.vpc_cidr

  azs = var.availability_zones

  public_subnets       = slice(var.public_subnets, 0, var.public_subnets_count)
  private_subnets      = slice(var.private_subnets, 0, var.private_subnets_count)

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = !var.single_nat_gateway

  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs
  enable_flow_log                      = var.enable_vpc_flow_logs
  create_flow_log_cloudwatch_iam_role  = var.enable_vpc_flow_logs
  create_flow_log_cloudwatch_log_group = var.enable_vpc_flow_logs
  flow_log_traffic_type                = "ALL"


  create_igw = true

  # Kubernetes-specific Tags for EKS

  # These tags help EKS identify subnets for load balancer placement

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = 1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  # VPC Tags
  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-vpc"
      Environment = var.environment
    }
  )
}
