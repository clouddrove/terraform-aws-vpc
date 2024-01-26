output "id" {
  value       = module.vpc[*].vpc_id
  description = "The ID of the VPC."
}

output "tags" {
  value       = module.vpc[*].tags
  description = "A mapping of tags to assign to the resource."
}

output "vpc_cidr" {
  value       = module.vpc[*].vpc_cidr_block
  description = "The primary IPv4 CIDR block"
}

output "vpc_ipv6_cidr_block" {
  value       = module.vpc[*].ipv6_cidr_block
  description = "The primary IPv6 CIDR block"
}

output "vpc_ipv6_association_id" {
  value       = module.vpc[*].vpc_ipv6_association_id
  description = "The association ID for the primary IPv6 CIDR block"
}

output "ipv6_cidr_block_network_border_group" {
  value       = module.vpc[*].ipv6_cidr_block_network_border_group
  description = "The Network Border Group Zone name"
}
