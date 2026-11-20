provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../.."

  name        = "vpc-ipam"
  environment = "prod"

  # Allocate IPv4 CIDR automatically from AWS IPAM Pool
  ipam_pool_enable    = true
  ipv4_ipam_pool_id   = "ipam-pool-0123456789abcdef0"
  ipv4_netmask_length = 20

  # Enable IPv6 Dual-Stack + Egress-Only IGW
  assign_generated_ipv6_cidr_block          = true
  enabled_ipv6_egress_only_internet_gateway = true
  enable_network_address_usage_metrics      = true
}
