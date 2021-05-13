# Managed By : CloudDrove
# Description : This Script is used to create VPC, Internet Gateway and Flow log.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
module "labels" {
  source = "git::https://github.com/clouddrove/terraform-labels.git?ref=tags/0.14.0"

  name        = var.name
  environment = var.environment
  attributes  = var.attributes
  repository  = var.repository
  managedby   = var.managedby
  label_order = var.label_order
}

#Module      : VPC
#Description : Terraform module to create VPC resource on AWS.
resource "aws_vpc" "default" {
  count = var.vpc_enabled ? 1 : 0

  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = true
  tags                             = module.labels.tags
  lifecycle {
    # Ignore tags added by kubernetes
    ignore_changes = [
      tags,
      tags["kubernetes.io"],
      tags["SubnetType"],
    ]
  }
}

#Module      : INTERNET GATEWAY
#Description : Terraform module which creates Internet Geteway resources on AWS
resource "aws_internet_gateway" "default" {
  count = var.vpc_enabled ? 1 : 0

  vpc_id = join("", aws_vpc.default.*.id)
  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-igw", module.labels.id)
    }
  )
}

#Module      : FLOW LOG
#Description : Provides a VPC/Subnet/ENI Flow Log to capture IP traffic for a
#              specific network interface, subnet, or VPC. Logs are sent to S3 Bucket.
resource "aws_flow_log" "vpc_flow_log" {
  count = var.vpc_enabled && var.enable_flow_log == true ? 1 : 0

  log_destination      = var.s3_bucket_arn
  log_destination_type = "s3"
  traffic_type         = var.traffic_type
  vpc_id               = join("", aws_vpc.default.*.id)
}

#Module      : Default Security Group
#Description : Ensure the default security group of every VPC restricts all traffic.
resource "aws_default_security_group" "default" {
  count = var.vpc_enabled && var.restrict_default_sg == true ? 1 : 0

  vpc_id = join("", aws_vpc.default.*.id)
  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-default-sg", module.labels.id)
    }
  )
}
