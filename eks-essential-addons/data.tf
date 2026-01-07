data "terraform_remote_state" "eks_infra" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "${data.external.master_s3_directory.result.master_s3_directory}/eks_infra/terraform.tfstate"
    region = var.aws_region
  }
}

data "external" "master_s3_directory" {
  program = ["bash", "${path.module}/get_env.sh"]
}
