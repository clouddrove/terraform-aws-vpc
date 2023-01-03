output "id" {
  value       = module.vpc.*.vpc_id
  description = "The ID of the VPC."
}

output "tags" {
  value       = module.vpc.*.tags
  description = "A mapping of tags to assign to the resource."
}