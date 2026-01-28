# ------------------------------------------------------------------------------
# General
# ------------------------------------------------------------------------------

variable "region" {
  description = "AWS region for all resources."
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, uat, prod)."
  type        = string
  validation {
    condition     = can(regex("^(dev|staging|uat|prod)$", var.environment))
    error_message = "Environment must be one of: dev, staging, uat, prod."
  }
}

# ------------------------------------------------------------------------------
# VPC
# ------------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "List of availability zone names (e.g. ap-southeast-1a, ap-southeast-1b)."
  type        = list(string)
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets (one per AZ)."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets (one per AZ)."
  type        = list(string)
}

variable "public_subnets_count" {
  description = "Number of public subnets to create."
  type        = number
}

variable "private_subnets_count" {
  description = "Number of private subnets to create."
  type        = number
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnet egress."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all AZs (cost optimization)."
  type        = bool
  default     = false
}

variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs to CloudWatch."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags for all resources."
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# EKS
# ------------------------------------------------------------------------------

variable "cluster_name" {
  description = "EKS cluster name (e.g. eks-dev, eks-prod)."
  type        = string
}

variable "eks_version" {
  description = "Kubernetes version for EKS (e.g. 1.31, 1.33)."
  type        = string
}
