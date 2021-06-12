provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {

  source  = "clouddrove/s3/aws"
  version = "0.14.0"

  name        = "clouddrov-12345"
  environment = "test"
  label_order = ["name", "environment"]

  bucket_enabled = true
  versioning     = true
  acl            = "private"
}

module "vpc" {
  source = "../"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  vpc_enabled           = true
  cidr_block            = "10.0.0.0/16"
  enable_flow_log       = true
  s3_bucket_arn         = module.s3_bucket.arn
  additional_cidr_block = ["172.3.0.0/16", "172.2.0.0/16"]
}
