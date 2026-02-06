module "eks_custom_addons" {
  source = "git::https://github.com/orbitcluster/oc-terraform-module-custom-addons.git?ref=6c45c6c8614fb29cac20c57cf1cb8b70afc71817"

  # Basic Cluster Info
  env    = var.env
  bu_id  = var.bu_id
  app_id = var.app_id

  is_hub = var.is_hub

  # Essential Addons - Values from remote state
  cluster_name                       = data.terraform_remote_state.eks_infra.outputs.cluster_name
  cluster_endpoint                   = data.terraform_remote_state.eks_infra.outputs.cluster_endpoint
  cluster_certificate_authority_data = data.terraform_remote_state.eks_infra.outputs.cluster_certificate_authority_data
  cluster_oidc_provider_arn          = data.terraform_remote_state.eks_infra.outputs.cluster_oidc_provider_arn
  cluster_oidc_issuer_url            = data.terraform_remote_state.eks_infra.outputs.cluster_oidc_issuer_url

  # Custom Addons
  enable_istio       = var.enable_istio
  istio_version      = var.istio_version
  enable_kiali       = var.enable_kiali
  kiali_version      = var.kiali_version
  argocd_version     = var.argocd_version
  enable_prometheus  = var.enable_prometheus
  prometheus_version = var.prometheus_version
  enable_grafana     = var.enable_grafana
  grafana_version    = var.grafana_version
  domain_url         = var.domain_url

  tags = var.tags
}
