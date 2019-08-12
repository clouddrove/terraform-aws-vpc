#Module      : VPC
#Description : Terraform module to create VPC resource on AWS.
output "vpc_id" {
  value = concat(
    aws_vpc.default.*.id
  )[0]
  description = "The ID of the VPC."
}

output "vpc_cidr_block" {
  value = concat(
    aws_vpc.default.*.cidr_block
  )[0]
  description = "The CIDR block of the VPC."
}

output "vpc_main_route_table_id" {
  value = concat(
    aws_vpc.default.*.main_route_table_id
  )[0]
  description = "The ID of the main route table associated with this VPC."
}

output "vpc_default_network_acl_id" {
  value = concat(
    aws_vpc.default.*.default_network_acl_id
  )[0]
  description = "The ID of the network ACL created by default on VPC creation."
}

output "vpc_default_security_group_id" {
  value = concat(
    aws_vpc.default.*.default_security_group_id
  )[0]
  description = "The ID of the security group created by default on VPC creation."
}

output "vpc_default_route_table_id" {
  value = concat(
    aws_vpc.default.*.default_route_table_id
  )[0]
  description = "The ID of the route table created by default on VPC creation."
}

output "vpc_ipv6_association_id" {
  value = concat(
    aws_vpc.default.*.ipv6_association_id
  )[0]
  description = "The association ID for the IPv6 CIDR block."
}

output "ipv6_cidr_block" {
  value = concat(
    aws_vpc.default.*.ipv6_cidr_block
  )[0]
  description = "The IPv6 CIDR block."
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}

#Module      : INTERNET GATEWAY
#Description : Terraform internet gateway module output variables.
output "igw_id" {
  value = concat(
    aws_internet_gateway.default.*.id
  )[0]
  description = "The ID of the Internet Gateway."
}