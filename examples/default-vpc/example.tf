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

  name               = local.name
  environment        = local.environment
  enable             = true
  enable_default_vpc = true

  # Set this to true when the default VPC should be deleted from AWS on destroy.
  default_vpc_force_destroy = true
}
