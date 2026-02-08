################################################################################
# Spoke ArgoCD Role Outputs
################################################################################

output "argocd_spoke_role_arn" {
  description = "IAM role ARN for hub ArgoCD to assume (only for spoke clusters)"
  value       = try(module.eks_custom_addons.argocd_spoke_role_arn, null)
}

output "argocd_spoke_role_name" {
  description = "IAM role name for hub ArgoCD to assume (only for spoke clusters)"
  value       = try(module.eks_custom_addons.argocd_spoke_role_name, null)
}
