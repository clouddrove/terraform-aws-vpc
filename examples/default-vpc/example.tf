provider "aws" {
  region = "us-west-2"
}

locals {
  name        = "vpc"
  environment = "example"
}

##-----------------------------------------------------------------------------
## Default VPC Module Call.
##-----------------------------------------------------------------------------
module "vpc" {
  source = "../.."

  name                                = local.name
  environment                         = local.environment
  enable_flow_log                     = true
  create_flow_log_cloudwatch_iam_role = true
  enable                              = true
  enable_default_vpc                  = true

  # Set this to true when the default VPC should be deleted from AWS on destroy.
  default_vpc_force_destroy                      = true
  manage_default_vpc_default_subnets             = true
  delete_default_vpc_internet_gateway_on_destroy = true
}
