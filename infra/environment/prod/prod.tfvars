environment  = "prod"
vpc_cidr     = "10.3.0.0/16"
cluster_name = "eks-prod"

public_subnets = [
  "10.3.1.0/24",
  "10.3.2.0/24",
  "10.3.3.0/24"
]

private_subnets = [
  "10.3.11.0/24",
  "10.3.12.0/24",
  "10.3.13.0/24"
]
