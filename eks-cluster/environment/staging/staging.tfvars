environment  = "staging"
vpc_cidr     = "10.2.0.0/16"
cluster_name = "eks-staging"

public_subnets = [
  "10.2.1.0/24",
  "10.2.2.0/24",
  "10.2.3.0/24"
]

private_subnets = [
  "10.2.11.0/24",
  "10.2.12.0/24",
  "10.2.13.0/24"
]
