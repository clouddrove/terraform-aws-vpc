provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}

resource "aws_vpc_ipam" "this" {
  operating_regions {
    region_name = data.aws_region.current.region
  }
}

resource "aws_vpc_ipam_pool" "ipv4" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.this.private_default_scope_id
  locale         = data.aws_region.current.region
}

resource "aws_vpc_ipam_pool_cidr" "ipv4" {
  ipam_pool_id = aws_vpc_ipam_pool.ipv4.id
  cidr         = "10.0.0.0/16"
}

module "vpc" {
  source = "../.."

  name        = "vpc-ipam"
  environment = "prod"

  # Allocate IPv4 CIDR automatically from the IPAM Pool above
  ipam_pool_enable    = true
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.ipv4.id
  ipv4_netmask_length = 20

  # Enable IPv6 Dual-Stack + Egress-Only IGW
  assign_generated_ipv6_cidr_block          = true
  enabled_ipv6_egress_only_internet_gateway = true
  enable_network_address_usage_metrics      = true

  depends_on = [aws_vpc_ipam_pool_cidr.ipv4]
}

