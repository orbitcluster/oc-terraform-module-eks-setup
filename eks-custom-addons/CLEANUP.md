# Cleanup Mechanism Documentation

## 1. Why is this cleanup script required?

When you manage an EKS cluster with Terraform, Terraform tracks resources it creates (like the EKS cluster itself, IAM roles, etc.) in its state file. However, Kubernetes workloads often create **dynamic AWS resources** that Terraform is unaware of:

*   **Ingress** objects create AWS Application Load Balancers (ALBs).
*   **Services** (type LoadBalancer) create AWS Network Load Balancers (NLBs) or Classic ELBs.
*   **PersistentVolumeClaims (PVCs)** create AWS EBS Volumes.
*   **VolumeSnapshots** create AWS EBS Snapshots.

These AWS resources are managed by **Kubernetes Addons** (AWS Load Balancer Controller, EBS CSI Driver) running inside the cluster.

**The Problem:**
When you run `terraform destroy`, Terraform destroys the EKS cluster and the Addons. If the dynamic resources (ALBs, EBS volumes) still exist, the Addons are killed *before* they can clean up these resources. This leaves "orphaned" resources in your AWS account that continue to cost money and require manual deletion.

**The Solution:**
We must explicitly tell the Addons to delete these resources *before* we kill the Addons themselves. The script does exactly this.

## 2. What is this script used for?

The script `cleanup-k8s-resources.sh` acts as a "destructor" for the dynamic resources. It connects to the cluster and issues delete commands for the Kubernetes objects that trigger AWS resource creation using a safe `delete_if_exists` check:

*   Deletes **Ingress** $\rightarrow$ Triggers AWS Load Balancer Controller to delete **ALBs**.
*   Deletes **LoadBalancer Services** $\rightarrow$ Triggers Controller to delete **NLBs**.
*   Deletes **PVCs** $\rightarrow$ Triggers EBS CSI Driver to delete **EBS Volumes**.
*   Deletes **VolumeSnapshots** $\rightarrow$ Triggers Driver to delete **EBS Snapshots**.

It then waits (sleeps) to give the controllers enough time to process these deletions before Terraform proceeds.

## 3. What is the sequence of execution of destroy?

The cleanup logic relies on Terraform's dependency graph to run at the precise moment:

1.  **Trigger**: You run `terraform destroy` (or the workflow runs it).
2.  **Phase 1: Custom Addons Destroy**
    *   Terraform identifies that `null_resource.cleanup_k8s_resources` depends on `module.eks_custom_addons`.
    *   **Reverse Dependency**: In destroy mode, Terraform destroys dependent resources *first*.
    *   **Cleanup Execution**: `null_resource.cleanup_k8s_resources` is destroyed. The `local-exec` provisioner runs the cleanup script.
    *   **AWS Cleanup**: The script deletes K8s objects. The **AWS Load Balancer Controller** and **EBS CSI Driver** (which are running in the *Essential Addons* layer and are still alive) detect these deletions and remove the physical AWS resources.
    *   **Module Destroy**: After the script finishes, Terraform destroys `module.eks_custom_addons`.
3.  **Phase 2: Essential Addons Destroy**
    *   Terraform destroys `eks_essential_addons` (removing the Controllers).
4.  **Phase 3: Infrastructure Destroy**
    *   Terraform destroys the EKS cluster itself.

## 4. Syntax Explanation

Here is the breakdown of the Terraform block used to implement this:

```hcl
resource "null_resource" "cleanup_k8s_resources" {
  # 1. Triggers
  triggers = {
    cluster_name = data.terraform_remote_state.eks_infra.outputs.cluster_name
    region       = data.aws_region.current.name
  }

  # 2. Provisioner
  provisioner "local-exec" {
    when    = destroy
    command = "/bin/bash ${path.module}/scripts/cleanup-k8s-resources.sh ${self.triggers.cluster_name} ${self.triggers.region}"
  }

  # 3. Dependency
  depends_on = [module.eks_custom_addons]
}
```

*   **`resource "null_resource"`**: A resource that doesn't create anything in AWS but allows us to run local scripts within the Terraform lifecycle.
*   **`triggers`**:
    *   **Purpose**: Stores values (`cluster_name`, `region`) in the Terraform state file.
    *   **Why?**: During `trigger destroy`, Terraform cannot read the current variables or data sources if dependencies are already gone. It MUST use the data stored in the state from when the resource was created. We access these via `${self.triggers.variable}`.
*   **`provisioner "local-exec"`**:
    *   **`when = destroy`**: Tells Terraform to run this command *only* when the resource is being destroyed (i.e., during `terraform destroy`). By default, provisioners run during creation.
    *   **`command`**: The shell command to execute the script using the correct path and arguments.
*   **`depends_on = [module.eks_custom_addons]`**:
    *   **Purpose**: Creates an explicit dependency relationship.
    *   **Effect**: Ensures `cleanup_k8s_resources` depends on the module. This forces Terraform to destroy `cleanup_k8s_resources` (running the script) **BEFORE** it destroys `module.eks_custom_addons`.
