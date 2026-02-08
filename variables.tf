#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-vpc"
  description = "Terraform current module repo"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'"
}

#Module      : VPC
#Description : Terraform VPC module variables.
variable "enable" {
  type        = bool
  default     = true
  description = "Flag to control the vpc creation."
}

variable "restrict_default_sg" {
  type        = bool
  default     = true
  description = "Flag to control the restrict default sg creation."
}

variable "cidr_block" {
  type        = string
  default     = ""
  description = "CIDR for the VPC."
}

variable "additional_cidr_block" {
  type        = list(string)
  default     = []
  description = "	List of secondary CIDR blocks of the VPC."
}

variable "ipv6_cidr_block" {
  type        = string
  default     = null
  description = "IPv6 CIDR for the VPC."
}

variable "instance_tenancy" {
  type        = string
  default     = "default"
  description = "A tenancy option for instances launched into the VPC."
}

variable "dns_hostnames_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
}

variable "dns_support_enabled" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable DNS support in the VPC."
}

#Module      : FLOW LOG
#Description : Terraform flow log module variables.
variable "enable_flow_log" {
  type        = bool
  default     = false
  description = "Enable vpc_flow_log logs."
}

variable "ipv4_ipam_pool_id" {
  type        = string
  default     = ""
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR."
}

variable "ipv4_netmask_length" {
  type        = string
  default     = null
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv4_ipam_pool_id"
}

variable "ipv6_ipam_pool_id" {
  type        = string
  default     = null
  description = "The ID of an IPv6 IPAM pool you want to use for allocating this VPC's CIDR."
}

variable "ipv6_netmask_length" {
  type        = string
  default     = null
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv6_ipam_pool_id"
}

variable "default_security_group_ingress" {
  type        = list(map(string))
  default     = []
  description = "List of maps of ingress rules to set on the default security group"
}

variable "default_security_group_egress" {
  type        = list(map(string))
  default     = []
  description = "List of maps of egress rules to set on the default security group"
}

variable "enable_dhcp_options" {
  type        = bool
  default     = false
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
}

variable "dhcp_options_domain_name" {
  type        = string
  default     = "service.consul"
  description = "Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)"
}

variable "dhcp_options_domain_name_servers" {
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
}

variable "dhcp_options_ntp_servers" {
  type        = list(string)
  default     = []
  description = "Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)"
}

variable "dhcp_options_netbios_name_servers" {
  type        = list(string)
  default     = []
  description = "Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)"
}

variable "dhcp_options_netbios_node_type" {
  type        = string
  default     = ""
  description = "Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)"
}

variable "enabled_ipv6_egress_only_internet_gateway" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable IPv6 Egress-Only Internet Gateway creation"
}

variable "ipv6_cidr_block_network_border_group" {
  type        = string
  default     = null
  description = "Set this to restrict advertisement of public addresses to a specific Network Border Group such as a LocalZone."
}

variable "aws_default_route_table" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable Default Route Table in the VPC."
}

variable "enable_network_address_usage_metrics" {
  type        = bool
  default     = null
  description = "Determines whether network address usage metrics are enabled for the VPC"
}

variable "assign_generated_ipv6_cidr_block" {
  type        = bool
  default     = true
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Conflicts with ipv6_ipam_pool_id"
}

variable "aws_default_network_acl" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable Default Network acl in the VPC."
}

variable "flow_logs_bucket_name" {
  type        = string
  default     = null
  description = "Name  (e.g. `mybucket` or `bucket101`)."
}

variable "ipam_pool_enable" {
  type        = bool
  default     = false
  description = "Flag to be set true when using ipam for cidr."
}

variable "default_route_table_routes" {
  type        = list(map(string))
  default     = []
  description = "Configuration block of routes."
}

variable "default_network_acl_ingress" {
  description = "List of maps of ingress rules to set on the Default Network ACL"
  type        = list(map(string))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "default_network_acl_egress" {
  description = "List of maps of egress rules to set on the Default Network ACL"
  type        = list(map(string))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "flow_log_destination_type" {
  type        = string
  default     = "cloud-watch-logs"
  description = "Type of flow log destination. Can be s3 or cloud-watch-logs"
}

variable "flow_log_log_format" {
  type        = string
  default     = null
  description = "The fields to include in the flow log record, in the order in which they should appear"
}

variable "flow_log_file_format" {
  type        = string
  default     = null
  description = "(Optional) The format for the flow log. Valid values: `plain-text`, `parquet`"
}

variable "flow_log_hive_compatible_partitions" {
  type        = bool
  default     = false
  description = "(Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3"
}

variable "flow_log_per_hour_partition" {
  type        = bool
  default     = false
  description = "(Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries"
}

variable "flow_log_max_aggregation_interval" {
  type        = number
  default     = 600
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds"
}

variable "flow_log_traffic_type" {
  type        = string
  default     = "ALL"
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL"
}

variable "create_flow_log_cloudwatch_iam_role" {
  type        = bool
  default     = false
  description = "Flag to be set true when cloudwatch iam role is to be created when flow log destination type is set to cloudwatch logs."
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  type        = number
  default     = null
  description = "Specifies the number of days you want to retain log events in the specified log group for VPC flow logs"
}

variable "vpc_flow_log_permissions_boundary" {
  type        = string
  default     = null
  description = "The ARN of the Permissions Boundary for the VPC Flow Log IAM Role"
}

variable "flow_log_iam_role_arn" {
  type        = string
  default     = null
  description = "The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow_log_destination_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided"
}

variable "kms_key_deletion_window" {
  type        = number
  default     = 10
  description = "KMS Key deletion window in days."
}

variable "flow_log_destination_arn" {
  type        = string
  default     = null
  description = "ARN of destination where vpc flow logs are to stored. Can be of existing s3 or existing cloudwatch log group."
}

variable "s3_sse_algorithm" {
  type        = string
  default     = "aws:kms"
  description = "Server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
}

variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled. Defaults to true(security best practice)"
}

variable "block_http_traffic" {
  type        = bool
  default     = true
  description = "True when http traffic has to be blocked for S3."
}