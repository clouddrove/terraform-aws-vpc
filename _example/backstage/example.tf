provider "aws" {
  region = var.awsRegion
  access_key = var.access_key
  secret_key = var.secret_key
}

terraform {
  backend "s3" {
    bucket = format("%s-clouddrove-s3", var.vpcName)
    key    = format("%s-clouddrove-s3/terraform.tfstate", var.vpcName) 
    region = var.awsRegion
  }
}

locals {
  name        = "vpc"
  environment = "example"
}

module "s3_bucket" {
  source  = "clouddrove/s3/aws"
  version = "2.0.0"

  name        = format("%s-clouddrove-s3", var.vpcName)
  environment = "test"
  s3_name     = format("%s-clouddrove-s3", var.vpcName)
  acl         = "private"
  versioning  = true
}

##-----------------------------------------------------------------------------
## VPC Module Call.
##-----------------------------------------------------------------------------
module "vpc" {
  source = "../.."

  name                                = local.name
  environment                         = local.environment
  enable                              = true
  cidr_block                          = "10.0.0.0/16"
  enable_flow_log                     = true # Flow logs will be stored in cloudwatch log group. Variables passed in default.
  create_flow_log_cloudwatch_iam_role = true
  additional_cidr_block               = ["172.3.0.0/16", "172.2.0.0/16"]
  dhcp_options_domain_name            = "service.consul"
  dhcp_options_domain_name_servers    = ["127.0.0.1", "10.10.0.2"]
}
