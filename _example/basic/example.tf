##-----------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
##-----------------------------------------------------------------------------
provider "aws" {
  region = "us-west-1"
}
##-----------------------------------------------------------------------------
## A VPC is a virtual network that closely resembles a traditional network that you'd operate in your own data center.
##-----------------------------------------------------------------------------
module "vpc" {
  source                           = "../.."
  name                             = "vpc"
  environment                      = "example"
  label_order                      = ["name", "environment"]
  cidr_block                       = "10.0.0.0/16"
  additional_cidr_block            = ["172.3.0.0/16", "172.2.0.0/16"]
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]
}
