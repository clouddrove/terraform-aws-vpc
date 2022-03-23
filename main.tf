# Managed By : CloudDrove
# Description : This Script is used to create VPC, Internet Gateway and Flow log.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : labels
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "0.15.0"

  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
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
  ipv4_ipam_pool_id                = var.ipv4_ipam_pool_id
  ipv4_netmask_length              = var.ipv4_ipam_pool_id != "" ? var.ipv4_netmask_length : null
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
  tags                 = module.labels.tags
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {

  for_each   = toset(var.additional_cidr_block)
  vpc_id     = join("", aws_vpc.default.*.id)
  cidr_block = each.key
}

#Module      : Default Security Group
#Description : Ensure the default security group of every VPC restricts all traffic.
resource "aws_default_security_group" "default" {
  count = var.vpc_enabled && var.restrict_default_sg == true ? 1 : 0

  vpc_id = join("", aws_vpc.default.*.id)

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self             = lookup(ingress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(ingress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(ingress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(ingress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(ingress.value, "security_groups", "")))
      description      = lookup(ingress.value, "description", null)
      from_port        = lookup(ingress.value, "from_port", 0)
      to_port          = lookup(ingress.value, "to_port", 0)
      protocol         = lookup(ingress.value, "protocol", "-1")
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress
    content {
      self             = lookup(egress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(egress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(egress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(egress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(egress.value, "security_groups", "")))
      description      = lookup(egress.value, "description", null)
      from_port        = lookup(egress.value, "from_port", 0)
      to_port          = lookup(egress.value, "to_port", 0)
      protocol         = lookup(egress.value, "protocol", "-1")
    }
  }

  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-default-sg", module.labels.id)
    }
  )
}
########################
# DHCP Options Set
########################
resource "aws_vpc_dhcp_options" "vpc_dhcp" {
  count = var.vpc_enabled && var.enable_dhcp_options ? 1 : 0

  domain_name          = var.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type

  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-vpc_dhcp", module.labels.id)
    }
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = var.vpc_enabled && var.enable_dhcp_options ? 1 : 0

  vpc_id          = join("", aws_vpc.default.*.id)
  dhcp_options_id = join("", aws_vpc_dhcp_options.vpc_dhcp.*.id)
}

resource "aws_egress_only_internet_gateway" "default" {
  count = var.vpc_enabled && var.enabled_ipv6_egress_only_internet_gateway ? 1 : 0

  vpc_id = join("", aws_vpc.default.*.id)
  tags   = module.labels.tags
}

