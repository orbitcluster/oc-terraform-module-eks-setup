
variable "cluster_kubernetes_version" {
  description = "Kubernetes <major>.<minor> version to use for the cluster"
  type        = string
  default     = "1.30"
}

variable "cluster_access_entries" {
  description = "Map of cluster access entries to use for the cluster"
  type        = any
  default     = {}
}


variable "cluster_enabled_log_types" {
  description = "List of log types to enable for the cluster"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cloudinit_pre_nodeadm" {
  description = "Optional: Cloudinit pre-nodeadm script to use for the cluster"
  type = list(object({
    content_type = string
    content      = string
  }))
  default = []
}

variable "cloudinit_post_nodeadm" {
  description = "Optional: Cloudinit post-nodeadm script to use for the cluster"
  type = list(object({
    content_type = string
    content      = string
  }))
  default = []
}

variable "ami_type" {
  description = "AMI type to use for the cluster"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "node_instance_type" {
  description = "Instance type to use for the cluster nodes"
  type        = string
  default     = "t3.medium"
}

variable "min_size" {
  description = "Minimum number of nodes to use for the cluster nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes to use for the cluster nodes"
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "Desired number of nodes to use for the cluster nodes"
  type        = number
  default     = 2
}

variable "max_pods_per_node" {
  description = "Maximum number of pods to use for the cluster nodes"
  type        = number
  default     = 30
}

variable "iam_role_permissions_boundary" {
  description = "IAM role permissions boundary to use for the cluster"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
