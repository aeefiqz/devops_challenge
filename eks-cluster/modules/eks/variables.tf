variable "environment" {
  description = "Environment name (dev, staging, uat, prod)."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name (e.g. eks-dev, eks-prod)."
  type        = string
}

variable "eks_version" {
  description = "Kubernetes version for EKS (e.g. 1.31, 1.33)."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS nodes."
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "List of subnet IDs for EKS control plane."
  type        = list(string)
}