environment  = "dev"
vpc_cidr     = "10.0.0.0/16"
cluster_name = "eks-dev"

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

private_subnets = [
  "10.0.11.0/24",
  "10.0.12.0/24",
  "10.0.13.0/24"
]
