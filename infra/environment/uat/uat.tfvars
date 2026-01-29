environment  = "uat"
vpc_cidr     = "10.1.0.0/16"
cluster_name = "eks-uat"

public_subnets = [
  "10.1.1.0/24",
  "10.1.2.0/24",
  "10.1.3.0/24"
]

private_subnets = [
  "10.1.11.0/24",
  "10.1.12.0/24",
  "10.1.13.0/24"
]
