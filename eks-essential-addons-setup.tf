module "eks_essential_addons" {
  source = "git::https://github.com/orbitcluster/oc-terraform-essential-addons.git?ref=072d83b598eb57134ccf752da8c6cdbf86d50303"

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
  tags                               = var.tags

  depends_on = [module.eks_infra]

}
