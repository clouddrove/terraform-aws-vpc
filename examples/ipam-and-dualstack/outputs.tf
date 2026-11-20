output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC."
}

output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "The IPv4 CIDR block allocated to the VPC from IPAM."
}

output "ipv6_cidr_block" {
  value       = module.vpc.ipv6_cidr_block
  description = "The IPv6 CIDR block associated with the VPC."
}

output "tags" {
  value       = module.vpc.tags
  description = "A mapping of tags assigned to the VPC resources."
}
