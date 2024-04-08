provider "aws" {
  region = "us-west-1"
}

locals {
  name        = "vpc"
  environment = "example"
}
##-----------------------------------------------------------------------------
## VPC Module Call.
##-----------------------------------------------------------------------------
module "vpc" {
  source = "../.."

  name                             = local.name
  environment                      = local.environment
  cidr_block                       = "10.0.0.0/16"
  enable_flow_log                  = true
  enable                           = true
  flow_log_destination_type        = "s3"
  flow_logs_bucket_name            = "gc-vpc-flow-logs-bucket"
  additional_cidr_block            = ["172.3.0.0/16", "172.2.0.0/16"]
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]
}
