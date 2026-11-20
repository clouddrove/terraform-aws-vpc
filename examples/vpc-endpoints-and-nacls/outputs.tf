output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC."
}

output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "The IPv4 CIDR block of the VPC."
}

output "vpc_default_security_group_id" {
  value       = module.vpc.vpc_default_security_group_id
  description = "The ID of the default security group created by default on VPC creation."
}

output "custom_nacl_ids" {
  value       = module.vpc.custom_nacl_ids
  description = "Map of custom Network ACL IDs created in the VPC."
}

output "tags" {
  value       = module.vpc.tags
  description = "A mapping of tags assigned to the VPC resources."
}
