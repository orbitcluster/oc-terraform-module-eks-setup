module "eks_essential_addons" {
  source = "git::https://github.com/orbitcluster/oc-terraform-essential-addons.git?ref=dff5dd7b7d98bbf594fe5e85bd9328eec472b319"

  # Basic Cluster Info
  env    = var.env
  bu_id  = var.bu_id
  app_id = var.app_id

  # Essential Addons
  cluster_name                       = module.eks_infra.cluster_name
  cluster_endpoint                   = module.eks_infra.cluster_endpoint
  cluster_certificate_authority_data = module.eks_infra.cluster_certificate_authority_data
  cluster_oidc_provider_arn          = module.eks_infra.cluster_oidc_provider_arn
  cluster_oidc_issuer_url            = module.eks_infra.cluster_oidc_issuer_url

  vpc_id                    = module.networking.vpc_id
  cluster_service_ipv4_cidr = module.eks_infra.cluster_service_cidr

  tags = var.tags

  depends_on = [module.eks_infra]

}
