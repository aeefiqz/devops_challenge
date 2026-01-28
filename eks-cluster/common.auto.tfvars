# ------------------------------------------------------------------------------
# Shared configuration (DRY). Override per-env via -var-file=environment/<env>/<env>.tfvars
# ------------------------------------------------------------------------------

region = "ap-southeast-1"

availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]

public_subnets_count  = 2
private_subnets_count = 2

enable_nat_gateway   = true
single_nat_gateway   = false
enable_vpc_flow_logs = true

eks_version = "1.33"
