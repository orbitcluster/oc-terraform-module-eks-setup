# oc-terraform-module-eks-setup
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.15.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_networking"></a> [networking](#module\_networking) | github.com/orbitcluster/oc-terraform-module-networking | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_access_logs_bucket_name"></a> [alb\_access\_logs\_bucket\_name](#input\_alb\_access\_logs\_bucket\_name) | S3 bucket name for ALB access logs. If null, logging is disabled | `string` | `null` | no |
| <a name="input_alb_access_logs_prefix"></a> [alb\_access\_logs\_prefix](#input\_alb\_access\_logs\_prefix) | S3 prefix for ALB access logs | `string` | `null` | no |
| <a name="input_alb_certificate_arn"></a> [alb\_certificate\_arn](#input\_alb\_certificate\_arn) | ARN of ACM certificate for HTTPS listener | `string` | `null` | no |
| <a name="input_alb_deletion_protection"></a> [alb\_deletion\_protection](#input\_alb\_deletion\_protection) | Enable deletion protection for ALB | `bool` | `true` | no |
| <a name="input_alb_http_enabled"></a> [alb\_http\_enabled](#input\_alb\_http\_enabled) | Enable HTTP listener for ALB | `bool` | `true` | no |
| <a name="input_alb_https_enabled"></a> [alb\_https\_enabled](#input\_alb\_https\_enabled) | Enable HTTPS listener for ALB | `bool` | `true` | no |
| <a name="input_alb_ingress_cidr_blocks"></a> [alb\_ingress\_cidr\_blocks](#input\_alb\_ingress\_cidr\_blocks) | List of CIDR blocks to allow ingress to ALB (HTTP/HTTPS) | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_alb_subnet_ids"></a> [alb\_subnet\_ids](#input\_alb\_subnet\_ids) | Subnet IDs for ALB. If not specified, uses public subnets | `list(string)` | `[]` | no |
| <a name="input_app_id"></a> [app\_id](#input\_app\_id) | application Unit | `string` | `null` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | List of availability zones. If not provided, will auto-detect 2-3 AZs in the region | `list(string)` | `[]` | no |
| <a name="input_bu_id"></a> [bu\_id](#input\_bu\_id) | Business Unit | `string` | `null` | no |
| <a name="input_enable_alb"></a> [enable\_alb](#input\_enable\_alb) | Create Application Load Balancer | `bool` | `false` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames in VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support in VPC | `bool` | `true` | no |
| <a name="input_enable_flow_logs"></a> [enable\_flow\_logs](#input\_enable\_flow\_logs) | Enable VPC Flow Logs to CloudWatch | `bool` | `false` | no |
| <a name="input_enable_istio_support"></a> [enable\_istio\_support](#input\_enable\_istio\_support) | Configure security groups for Istio service mesh | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Enable NAT Gateway for private subnets | `bool` | `true` | no |
| <a name="input_enable_network_load_balancer"></a> [enable\_network\_load\_balancer](#input\_enable\_network\_load\_balancer) | Create Network Load Balancer in public subnets | `bool` | `false` | no |
| <a name="input_enable_vpc_endpoints"></a> [enable\_vpc\_endpoints](#input\_enable\_vpc\_endpoints) | Enable VPC endpoints for AWS services | `bool` | `true` | no |
| <a name="input_enable_vpn_gateway"></a> [enable\_vpn\_gateway](#input\_enable\_vpn\_gateway) | Enable VPN Gateway | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name (dev, staging, prod) | `string` | n/a | yes |
| <a name="input_flow_logs_retention_days"></a> [flow\_logs\_retention\_days](#input\_flow\_logs\_retention\_days) | CloudWatch log retention for flow logs in days | `number` | `7` | no |
| <a name="input_nlb_access_logs_bucket_name"></a> [nlb\_access\_logs\_bucket\_name](#input\_nlb\_access\_logs\_bucket\_name) | S3 bucket name for NLB access logs. If null, logging is disabled | `string` | `null` | no |
| <a name="input_nlb_access_logs_prefix"></a> [nlb\_access\_logs\_prefix](#input\_nlb\_access\_logs\_prefix) | S3 prefix for NLB access logs | `string` | `null` | no |
| <a name="input_nlb_deletion_protection"></a> [nlb\_deletion\_protection](#input\_nlb\_deletion\_protection) | Enable deletion protection for Network Load Balancer | `bool` | `true` | no |
| <a name="input_nlb_subnet_ids"></a> [nlb\_subnet\_ids](#input\_nlb\_subnet\_ids) | Subnet IDs for NLB. If not specified, uses public subnets | `list(string)` | `[]` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of CIDR blocks for private subnets. If not provided, will auto-calculate based on VPC CIDR | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of CIDR blocks for public subnets. If not provided, will auto-calculate based on VPC CIDR | `list(string)` | `[]` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Use single NAT Gateway to reduce costs (not recommended for production) | `bool` | `false` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_endpoints"></a> [vpc\_endpoints](#input\_vpc\_endpoints) | Map of VPC endpoints to create. Valid keys: ssm, ssmmessages, ec2messages, kms, ecr\_api, ecr\_dkr, ec2, sts, logs, s3, dynamodb | `map(bool)` | <pre>{<br/>  "dynamodb": false,<br/>  "ec2": true,<br/>  "ec2messages": true,<br/>  "ecr_api": true,<br/>  "ecr_dkr": true,<br/>  "kms": true,<br/>  "logs": true,<br/>  "s3": true,<br/>  "ssm": true,<br/>  "ssmmessages": true,<br/>  "sts": true<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
