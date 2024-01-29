provider "aws" {
  region = var.awsRegion
}

terraform {
  backend "s3" {
    bucket = "backstage-clouddrove-s3"
    key    = "backstage-clouddrove-s3/terraform.tfstate"
    region = "us-east-1"
  }
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

  name                                = var.vpcName
  environment                         = "test"
  enable                              = true
  cidr_block                          = "10.0.0.0/16"
  enable_flow_log                     = true # Flow logs will be stored in cloudwatch log group. Variables passed in default.
  create_flow_log_cloudwatch_iam_role = true
  additional_cidr_block               = ["172.3.0.0/16", "172.2.0.0/16"]
  dhcp_options_domain_name            = "service.consul"
  dhcp_options_domain_name_servers    = ["127.0.0.1", "10.10.0.2"]
}
