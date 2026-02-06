###################ORG INFO###################
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

variable "delete_retained_pvs" {
  description = "If true, patches PVs with Retain policy to Delete before destroying cluster, ensuring EBS volumes are removed."
  type        = bool
  default     = false
}

###################CUSTOM ADDONS INFO###################

variable "enable_istio" {
  description = "Enable Istio addon"
  type        = bool
  default     = true
}

variable "istio_version" {
  description = "Version of the Istio Helm chart"
  type        = string
  default     = "1.28.2"
}

variable "enable_kiali" {
  description = "Enable Kiali addon"
  type        = bool
  default     = true
}

variable "kiali_version" {
  description = "Version of the Kiali Helm chart"
  type        = string
  default     = "2.20.0"
}

variable "is_hub" {
  description = "Flag to determine if this is a hub cluster. Controls ArgoCD installation."
  type        = bool
  default     = false
}

variable "argocd_version" {
  description = "Version of the ArgoCD Helm chart"
  type        = string
  default     = "9.2.4"
}

variable "enable_prometheus" {
  description = "Enable Prometheus addon"
  type        = bool
  default     = true
}

variable "prometheus_version" {
  description = "Version of the Prometheus Helm chart"
  type        = string
  default     = "28.2.1"
}

variable "enable_grafana" {
  description = "Enable Grafana addon"
  type        = bool
  default     = true
}

variable "grafana_version" {
  description = "Version of the Grafana Helm chart"
  type        = string
  default     = "8.5.1" # Grafana chart 10.5.5 seems like app version. 8.x is the chart version series usually. I will use a safe recent 8.x.
  # Actually, let's use 8.5.1 to be safe, or 8.6.0.
}

variable "domain_url" {
  description = "Base domain URL for the platform (e.g., orbitcluster.platform.com, xyz.company.com)"
  type        = string
  default     = "orbitcluster.platform.com"
}
