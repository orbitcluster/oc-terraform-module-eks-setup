variables {
  bu_id  = "testbu"
  app_id = "testapp"
  env    = "test"
}

override_module {
  target = module.networking
  outputs = {
    vpc_id                          = "vpc-mock-12345"
    private_subnet_ids              = ["subnet-mock-1", "subnet-mock-2"]
    public_subnet_ids               = ["subnet-mock-public-1", "subnet-mock-public-2"]
    node_security_group_id          = "sg-mock-node"
    control_plane_security_group_id = "sg-mock-control-plane"
  }
}

run "naming_standard" {
  command = plan

  assert {
    condition     = output.cluster_name == "testbu-testapp-eks"
    error_message = "Cluster name did not follow naming standard '${bu_id}-${app_id}-eks'"
  }
}

run "nodegroup_configuration" {
  command = plan

  variables {
    node_instance_type = "m5.large"
    min_size           = 2
    max_size           = 4
    desired_size       = 2
  }

  assert {
    condition     = output.cluster_name == "testbu-testapp-eks"
    error_message = "Cluster name changed unexpectedly in nodegroup config"
  }
}

run "tagging" {
  command = plan

  variables {
    tags = {
      "Environment" = "Test"
      "Owner"       = "DevOps"
    }
  }

  assert {
    condition     = output.cluster_name == "testbu-testapp-eks"
    error_message = "Cluster name changed unexpectedly in tagging config"
  }
}
