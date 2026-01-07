data "terraform_remote_state" "eks_infra" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "${var.cluster_name}/eks_infra/terraform.tfstate"
    region = var.aws_region
  }
}
