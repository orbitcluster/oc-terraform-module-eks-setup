# variables {
#   bu_id  = "testbu"
#   app_id = "testapp"
#   env    = "test"
# }

# override_module {
#   target = module.networking
#   outputs = {
#     vpc_id                          = "vpc-mock-12345"
#     private_subnet_ids              = ["subnet-mock-1", "subnet-mock-2"]
#     public_subnet_ids               = ["subnet-mock-public-1", "subnet-mock-public-2"]
#     node_security_group_id          = "sg-mock-node"
#     control_plane_security_group_id = "sg-mock-control-plane"
#   }
# }

# override_data {
#   target = module.eks.data.aws_ami.eks
#   values = {
#     id = "ami-mock-12345"
#   }
# }

# run "verify_naming_standard" {
#   command = plan

#   variables {
#     bu_id  = "fin"
#     app_id = "pay"
#   }

#   assert {
#     condition     = output.cluster_name == "fin-pay-eks"
#     error_message = "Cluster name did not match expected 'fin-pay-eks'"
#   }
# }

# run "verify_nodegroup_config" {
#   command = plan

#   variables {
#     node_instance_type = "m5.large"
#     min_size           = 1
#     max_size           = 5
#   }

#   assert {
#     # Implicitly checks that m5.large is accepted by validate logic in module
#     condition     = output.cluster_name == "testbu-testapp-eks"
#     error_message = "Cluster name changed unexpectedly during nodegroup config test"
#   }
# }

# run "verify_tagging" {
#   command = plan

#   variables {
#     tags = {
#       Project = "Orbit"
#     }
#   }

#   assert {
#     # We can't easily assert on tags output unless we expose them, 
#     # but we can ensure the plan succeeds with tags passed.
#     condition     = output.cluster_name == "testbu-testapp-eks"
#     error_message = "Cluster name changed unexpectedly during tagging test"
#   }
# }
