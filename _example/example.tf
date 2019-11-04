provider "aws" {
  region = "eu-west-1"
}

module "s3_bucket" {
  source = "git::https://github.com/clouddrove/terraform-aws-s3.git?ref=tags/0.12.1"

  name        = "secure-bucket"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "name", "application"]

  region         = "eu-west-1"
  versioning     = true
  acl            = "private"
  bucket_enabled = true
}

module "vpc" {
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git?ref=tags/0.12.3"

  name        = "vpc"
  application = "clouddrove"
  environment = "test"
  label_order = ["environment", "application", "name"]

  cidr_block = "10.0.0.0/16"

  enable_flow_log = true
  s3_bucket_arn   = module.s3_bucket.arn
}
