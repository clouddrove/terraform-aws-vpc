####--------------------------------------------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
####---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "us-west-1"
}

####------------------------------------------------------------------------------------------------------------------
## A VPC is a virtual network that closely resembles a traditional network that you'd operate in your own data center.
####------------------------------------------------------------------------------------------------------------------

module "vpc" {
  source = "../"

  name        = "vpc"
  environment = "example"
  label_order = ["name", "environment"]

  vpc_enabled                               = true
  cidr_block                                = "10.0.0.0/16"
  enable_flow_log                           = false
  additional_cidr_block                     = ["172.3.0.0/16", "172.2.0.0/16"]
  enable_dhcp_options                       = false
  dhcp_options_domain_name                  = "service.consul"
  dhcp_options_domain_name_servers          = ["127.0.0.1", "10.10.0.2"]
  enabled_ipv6_egress_only_internet_gateway = true

  default_security_group_deny_all = true
  default_route_table_no_routes   = false
  default_network_acl_deny_all    = false
}
