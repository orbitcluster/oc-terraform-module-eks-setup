variable "terraform_state_bucket" {
  description = "S3 bucket containing the terraform state files"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the S3 backend"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string

  validation {
    condition     = can(regex("^(dev|staging|prod|test)$", var.env))
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "bu_id" {
  description = "Business Unit"
  type        = string
  default     = null
}

variable "app_id" {
  description = "Application Unit"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
