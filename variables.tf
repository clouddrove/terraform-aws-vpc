variable "application" {
  type        = "string"
  description = "Application (e.g. `cd` or `clouddrove`)"
}

variable "environment" {
  type        = "string"
  description = "Environment (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = "string"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "cidr_block" {
  type        = "string"
  description = "CIDR for the VPC"
  default     = ""
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default     = "true"
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  default     = "true"
}

variable "enable_classiclink" {
  description = "A boolean flag to enable/disable ClassicLink for the VPC"
  default     = "false"
}

variable "enable_classiclink_dns_support" {
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC"
  default     = "false"
}

variable "s3_bucket_arn" {
  description = "S3 ARN for vpc logs"
  default     = ""
}

variable "traffic_type" {
  description = "Type of traffic to capture. Valid values: ACCEPT,REJECT, ALL"
  default     = "ALL"
}

variable "vpc_flow_log" {
  description = "Enable vpc_flow_log logs"
  default     = "false"
}
