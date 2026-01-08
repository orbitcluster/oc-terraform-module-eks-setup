module "eks_essential_addons" {
  source = "git::https://github.com/orbitcluster/oc-terraform-module-essential-addons.git?ref=c52b48b75ee61a554630aab5f643d8c3618d4a39"

  # Basic Cluster Info
  env    = var.env
  bu_id  = var.bu_id
  app_id = var.app_id

  # Essential Addons - Values from remote state
  cluster_name                       = data.terraform_remote_state.eks_infra.outputs.cluster_name
  cluster_endpoint                   = data.terraform_remote_state.eks_infra.outputs.cluster_endpoint
  cluster_certificate_authority_data = data.terraform_remote_state.eks_infra.outputs.cluster_certificate_authority_data
  cluster_oidc_provider_arn          = data.terraform_remote_state.eks_infra.outputs.cluster_oidc_provider_arn
  cluster_oidc_issuer_url            = data.terraform_remote_state.eks_infra.outputs.cluster_oidc_issuer_url

  vpc_id                    = data.terraform_remote_state.eks_infra.outputs.vpc_id
  cluster_service_ipv4_cidr = data.terraform_remote_state.eks_infra.outputs.cluster_service_cidr

  tags = var.tags
}
