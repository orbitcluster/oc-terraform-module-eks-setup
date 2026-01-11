
resource "null_resource" "cleanup_k8s_resources" {
  triggers = {
    cluster_name = data.terraform_remote_state.eks_infra.outputs.cluster_name
    region       = data.aws_region.current.name
  }

  provisioner "local-exec" {
    when    = destroy
    command = "/bin/bash ${path.module}/scripts/cleanup-k8s-resources.sh ${self.triggers.cluster_name} ${self.triggers.region}"
  }

  depends_on = [module.eks_custom_addons]
}
