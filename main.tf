# Managed By : CloudDrove
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : Terraform module to create consistent naming for multiple names.
module "lables" {
  source      = "git::https://github.com/clouddrove/terraform-lables.git?ref=tags/0.11.0"
  name        = "${var.name}"
  application = "${var.application}"
  environment = "${var.environment}"
}

#Module      : VPC
#Description : Terraform module which creates VPC resources on AWS
resource "aws_vpc" "default" {
  cidr_block                       = "${var.cidr_block}"
  instance_tenancy                 = "${var.instance_tenancy}"
  enable_dns_hostnames             = "${var.enable_dns_hostnames}"
  enable_dns_support               = "${var.enable_dns_support}"
  enable_classiclink               = "${var.enable_classiclink}"
  enable_classiclink_dns_support   = "${var.enable_classiclink_dns_support}"
  assign_generated_ipv6_cidr_block = true
  tags                             = "${module.lables.tags}"
}

#Module      : INTERNET GATEWAY
#Description : Terraform module which creates Internet Geteway resources on AWS
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags   = "${module.lables.tags}"
}

#Module      : FLOW LOG
#Description : Provides a VPC/Subnet/ENI Flow Log to capture IP traffic for a
#              specific network interface, subnet, or VPC. Logs are sent to
#              S3 Bucket.
resource "aws_flow_log" "vpc_flow_log" {
  count                = "${var.vpc_flow_log == "true" ? 1 : 0}"
  log_destination      = "${var.s3_bucket_arn}"
  log_destination_type = "s3"
  traffic_type         = "${var.traffic_type}"
  vpc_id               = "${aws_vpc.default.id}"
}
