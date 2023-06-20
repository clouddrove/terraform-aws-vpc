# Managed By : CloudDrove
# Description : This Script is used to create VPC, Internet Gateway and Flow log.
# Copyright @ CloudDrove. All Right Reserved.

####------------------------------------------------------------------------------
#Module      : labels
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
####------------------------------------------------------------------------------
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "1.3.0"

  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}
###---------------------------------------------------------------------------------------
#Resource    : VPC
#Description : Terraform module to create VPC resource on AWS.
## A VPC is a virtual network that closely resembles a traditional network that you'd operate in your own data center.
###--------------------------------------------------------------------------------------------
resource "aws_vpc" "default" {
  count = var.vpc_enabled ? 1 : 0
  cidr_block          = var.cidr_block
  ipv4_ipam_pool_id   = try(var.additional_cidr_block.ipv4_ipam_pool_id, null)
  ipv4_netmask_length = try(var.additional_cidr_block.ipv4_netmask_length, null)

  ipv6_cidr_block     = try(var.additional_ipv6_cidr_block.ipv6_cidr_block, null)
  ipv6_ipam_pool_id   = try(var.additional_ipv6_cidr_block.ipv6_ipam_pool_id, null)
  ipv6_netmask_length = try(var.additional_ipv6_cidr_block.ipv6_netmask_length, null)

  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.dns_hostnames_enabled
  enable_dns_support               = var.dns_support_enabled
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
####-------------------------------------------------------------------------------------
#Resource     :VPC IPV4 CIDR BLOCK ASSOCIATION 
#Description  :Provides a resource to associate additional IPv4 CIDR blocks with a VPC.
####---------------------------------------------------------------------------------------
resource "aws_vpc_ipv4_cidr_block_association" "default" {

  for_each   = toset(var.additional_cidr_block)
  vpc_id     = join("", aws_vpc.default.*.id)
  cidr_block = each.key
}

####--------------------------------------------------------------------------------------
#Resource    : INTERNET GATEWAY
#Description : Terraform module which creates Internet Geteway resources on AWS
#              An AWS Internet Gateway virtual router that enables communication between VPC and the internet
####---------------------------------------------------------------------------------------
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
#####------------------------------------------------------------------------------------------------
#Resource    : EGRESS ONLY INTERNET GATEWAY
#Description : Terraform module which creates EGRESS ONLY INTERNET GATEWAY resources on AWS
#              An egress-only internet gateway provides outbound-only internet connectivity for resources within a VPC
##---------------------------------------------------------------------------------------------------

resource "aws_egress_only_internet_gateway" "default" {
  count = var.vpc_enabled && var.enabled_ipv6_egress_only_internet_gateway ? 1 : 0

  vpc_id = join("", aws_vpc.default.*.id)
  tags   = module.labels.tags
}

###--------------------------------------------------------------------------------
#Resource    : Default Security Group
#Description : Ensure the default security group of every VPC restricts all traffic. 
#              The default security group serves as a baseline security configuration within the VPC.             
####----------------------------------------------------------------------------------
resource "aws_default_security_group" "default" {
  count = var.vpc_enabled && var.restrict_default_sg == true ? 1 : 0

  vpc_id = join("", aws_vpc.default.*.id)

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self             = lookup(ingress.value, "self", true)
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
      self             = lookup(egress.value, "self", true)
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
##---------------------------------------------------------------------------------------
# Resource    : DEFAULT ROUTE TABLE
# Description : Provides a resource to manage a default route table of a VPC.
#              This resource can manage the default route table of the default or a non-default VPC.
#              Provides a resource to create an ASSOCIATION between gateway and routing table.
# #----------------------------------------------------------------------------------
resource "aws_default_route_table" "default" { 
  count = var.vpc_enabled && var.aws_default_route_table ? 1 : 0
  default_route_table_id = aws_vpc.default[0].default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default[0].id
  }
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.default[0].id
  }
    tags = merge(
      module.labels.tags,
    {
        "Name" = format("%s-default-rt", module.labels.id)
    }
  )
  
}

####--------------------------------------------------------------
#Resource    : VPC DHCP Option
#Description : Provides a VPC DHCP Options resource.
####--------------------------------------------------------------
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
      "Name" = format("%s-vpc-dhcp", module.labels.id)
    }
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = var.vpc_enabled && var.enable_dhcp_options ? 1 : 0

  vpc_id          = join("", aws_vpc.default.*.id)
  dhcp_options_id = join("", aws_vpc_dhcp_options.vpc_dhcp.*.id)
}
####--------------------------------------------------------------
#Resource    : kms key
#Description : Provides a kms key resource.
#              it create and control the cryptographic keys that are used to protect your data.
####-------------------------------------------------------------- 
resource "aws_kms_key" "kms" {
  count = var.enable_flow_log == true ? 1 : 0
  deletion_window_in_days = 10
}

####------------------------------------------------------------------------------
#Resource    : s3 bucket
#Description : Provides a s3 bucket resource.
#              S3 bucket is a public cloud storage resource available in AWS.
####------------------------------------------------------------------------------
resource "aws_s3_bucket" "mybucket" {
  count = var.enable_flow_log == true ? 1 : 0
  bucket = var.flow_logs_bucket_name
  acl = "private"
}
resource "aws_s3_bucket_public_access_block" "example" {
  count = var.enable_flow_log == true ? 1 : 0
  bucket = aws_s3_bucket.mybucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
####------------------------------------------------------------------------------
# Resource : s3 bucket server side encryption configuration
# Description : Provides a S3 bucket server-side encryption configuration resource.
####-------------------------------------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  count = var.enable_flow_log == true ? 1 : 0
  bucket = aws_s3_bucket.mybucket[0].id
  

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms[0].arn
      sse_algorithm     = "aws:kms"
    }
  }
}

##---------------------------------------------------------------------------------------------
#Resource    : FLOW LOG
#Description : Provides a VPC/Subnet/ENI Flow Log to capture IP traffic for a
#              specific network interface, subnet, or VPC. Logs are sent to S3 Bucket.
##---------------------------------------------------------------------------------------------
resource "aws_flow_log" "vpc_flow_log" {
  count = var.vpc_enabled && var.enable_flow_log == true ? 1 : 0

  log_destination      = join("", aws_s3_bucket.mybucket.*.arn)
  log_destination_type = "s3"
  traffic_type         = var.traffic_type
  vpc_id               = join("", aws_vpc.default.*.id)
  tags                 = module.labels.tags
}



##----------------------------------------------------------------------------------------------------
#Resource      : DEFAULT NETWORK ACL
## Provides an network ACL resource. You might set up network ACLs with rules
## similar to your security groups in order to add an additional layer of security to your VPC.
##-------------------------------------------------------------------------------------------------------

resource "aws_default_network_acl" "default" {
  count = var.vpc_enabled && var.aws_default_network_acl ? 1 : 0
  default_network_acl_id = aws_vpc.default[0].default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-nacl", module.labels.id)
    }
  )
}


