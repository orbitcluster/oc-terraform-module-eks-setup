locals {
  cluster_name = "eks-cluster-${var.org_id}-${var.is_hub ? "hub" : "spoke"}"

  kubernetes_version = 1.33
}
