variable "availability_zones" {
  description = "List of availability zones (automatically fetched from AWS)"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
  validation {
    condition     = can(regex("^(dev|staging|uat|prod)$", var.environment))
    error_message = "Environment must be one of: dev, staging, uat, prod."
  }
}

# VPC Configuration Variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid CIDR block."
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnet internet access"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway across all AZs (cost optimization)"
  type        = bool
  default     = false
}

variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs for network monitoring"
  type        = bool
  default     = true
}

variable "public_subnets_count" {
  description = "Count of public subnet to create"
  type        = number
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  validation {
    condition     = length(var.public_subnets) >= 2
    error_message = "At least 2 public subnets are required for high availability."
  }
}

variable "private_subnets_count" {
  description = "Count of private subnet to create"
  type        = number
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  validation {
    condition     = length(var.private_subnets) >= 2
    error_message = "At least 2 private subnets are required for high availability."
  }
}


variable "cluster_name" {
  description = "Name of the EKS cluster (used for Kubernetes tags)"
  type        = string
  default     = ""
}

variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.24"
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
  validation {
    condition     = can(regex("^(dev|staging|uat|prod)$", var.environment))
    error_message = "Environment must be one of: dev, staging, uat, prod."
  }
  
}
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "List of control plane subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}