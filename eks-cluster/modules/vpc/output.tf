output "vpc_id" {
  value = module.vpc.vpc_id # Export VPC ID
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets # Export subnet IDs
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}
