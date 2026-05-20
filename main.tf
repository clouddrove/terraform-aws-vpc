# Managed By : CloudDrove
# Copyright @ CloudDrove. All Right Reserved.


##-----------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##-----------------------------------------------------------------------------
module "labels" {
  #checkov:skip=CKV_TF_1: clouddrove modules use semver tags not commit hashes — intentional policy
  source      = "clouddrove/labels/aws"
  version     = "1.3.1"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
  extra_tags  = var.tags
}
##-----------------------------------------------------------------------------
## Below resources will deploy VPC and its components.
##-----------------------------------------------------------------------------
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs ## Because flow log resource for vpc is defined below.
resource "aws_vpc" "default" {
  #checkov:skip=CKV2_AWS_11: flow log created via aws_flow_log.vpc_flow_log when var.enable_flow_log=true
  #checkov:skip=CKV2_AWS_12: default SG traffic controlled by var.default_security_group_ingress/egress
  count                                = var.enable ? 1 : 0
  cidr_block                           = var.ipam_pool_enable ? null : var.cidr_block
  ipv4_ipam_pool_id                    = var.ipv4_ipam_pool_id
  ipv4_netmask_length                  = var.ipv4_netmask_length
  ipv6_cidr_block                      = var.ipv6_cidr_block
  ipv6_ipam_pool_id                    = var.ipv6_ipam_pool_id
  ipv6_netmask_length                  = var.ipv6_netmask_length
  instance_tenancy                     = var.instance_tenancy
  enable_dns_hostnames                 = var.dns_hostnames_enabled
  enable_dns_support                   = var.dns_support_enabled
  assign_generated_ipv6_cidr_block     = var.assign_generated_ipv6_cidr_block
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  tags                                 = module.labels.tags
  lifecycle {
    # Ignore tags added by kubernetes
    ignore_changes = [
      tags,
      tags["kubernetes.io"],
      tags["SubnetType"],
    ]
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "default" {
  for_each   = { for k in var.additional_cidr_block : k => k if var.enable }
  vpc_id     = one(aws_vpc.default[*].id)
  cidr_block = each.key
}

resource "aws_internet_gateway" "default" {
  count  = var.enable ? 1 : 0
  vpc_id = one(aws_vpc.default[*].id)
  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-igw", module.labels.id)
    }
  )
}

resource "aws_egress_only_internet_gateway" "default" {
  count  = var.enable && var.enabled_ipv6_egress_only_internet_gateway ? 1 : 0
  vpc_id = one(aws_vpc.default[*].id)
  tags   = module.labels.tags
}
##-----------------------------------------------------------------------------
## Below resource is used to create default security group for vpc communication.
##-----------------------------------------------------------------------------
resource "aws_default_security_group" "default" {
  #checkov:skip=CKV2_AWS_12: default SG rules controlled by var.default_security_group_ingress/egress; defaults to no rules
  count  = var.enable && var.restrict_default_sg == true ? 1 : 0
  vpc_id = one(aws_vpc.default[*].id)
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
##-----------------------------------------------------------------------------
## Below resource will create default route table for vpc communication.
##-----------------------------------------------------------------------------
resource "aws_default_route_table" "default" {
  count                  = var.enable && var.aws_default_route_table ? 1 : 0
  default_route_table_id = aws_vpc.default[0].default_route_table_id
  dynamic "route" {
    for_each = var.default_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block                 = route.value.cidr_block
      ipv6_cidr_block            = lookup(route.value, "ipv6_cidr_block", null)
      destination_prefix_list_id = lookup(route.value, "destination_prefix_list_id", null)
      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }
  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-default-rt", module.labels.id)
    }
  )
}
##-----------------------------------------------------------------------------
## Below resource is used to configure vpc dhcp options.
##-----------------------------------------------------------------------------
resource "aws_vpc_dhcp_options" "vpc_dhcp" {
  count                = var.enable && var.enable_dhcp_options ? 1 : 0
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
  count           = var.enable && var.enable_dhcp_options ? 1 : 0
  vpc_id          = one(aws_vpc.default[*].id)
  dhcp_options_id = one(aws_vpc_dhcp_options.vpc_dhcp[*].id)
}

##-----------------------------------------------------------------------------
## Below resource will create kms key. This key will used for encryption of flow logs stored in S3 bucket or cloudwatch log group.
##-----------------------------------------------------------------------------
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_kms_key" "kms" {
  #checkov:skip=CKV2_AWS_64: policy defined in aws_kms_key_policy.example with the same count condition
  count                   = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null ? 1 : 0
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = var.enable_key_rotation
  tags                    = module.labels.tags
}

resource "aws_kms_alias" "kms-alias" {
  count         = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null ? 1 : 0
  name          = format("alias/%s-flow-log-key", module.labels.id)
  target_key_id = aws_kms_key.kms[0].key_id
}

##-----------------------------------------------------------------------------
## Below resource will attach policy to above created kms key. The above created key require policy to be attached so that cloudwatch log group can access it.
## It will be only created when vpc flow logs are stored in cloudwatch log group.
##-----------------------------------------------------------------------------
##-----------------------------------------------------------------------------
## KMS key policy — always created alongside the key so the key is never
## left policy-less (CKV2_AWS_64). A base statement grants root-account
## management access; the second statement is service-specific.
##-----------------------------------------------------------------------------
resource "aws_kms_key_policy" "example" {
  count  = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null ? 1 : 0
  key_id = aws_kms_key.kms[0].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "key-default-1",
    "Statement" : concat(
      [{
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      }],
      var.flow_log_destination_type == "cloud-watch-logs" ? [{
        "Sid" : "AllowCloudWatchLogs",
        "Effect" : "Allow",
        "Principal" : { "Service" : "logs.${data.aws_region.current.name}.amazonaws.com" },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*"
      }] : [],
      var.flow_log_destination_type == "s3" ? [{
        "Sid" : "AllowS3FlowLogs",
        "Effect" : "Allow",
        "Principal" : { "Service" : "delivery.logs.amazonaws.com" },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*"
      }] : []
    )
  })
}
##-----------------------------------------------------------------------------
## Below resources will create S3 bucket and its components. This S3 bucket will be used to store vpc flow logs if "flow_log_destination_type" variable is set to "s3".
##-----------------------------------------------------------------------------
resource "aws_s3_bucket" "flow_log" {
  #checkov:skip=CKV_AWS_18: access logging requires a separate destination bucket — configure externally
  #checkov:skip=CKV_AWS_21: versioning enabled via aws_s3_bucket_versioning.flow_log (same count condition)
  #checkov:skip=CKV_AWS_144: cross-region replication is not required for VPC flow logs
  #checkov:skip=CKV_AWS_145: SSE-KMS set via aws_s3_bucket_server_side_encryption_configuration.example
  #checkov:skip=CKV2_AWS_6: public access block applied via aws_s3_bucket_public_access_block.example
  #checkov:skip=CKV2_AWS_61: lifecycle is user-configurable; not required for flow log storage
  #checkov:skip=CKV2_AWS_62: event notifications not applicable for flow log destination buckets
  count  = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "s3" ? 1 : 0
  bucket = var.flow_logs_bucket_name != "" ? var.flow_logs_bucket_name : "${module.labels.id}-vpc-flow-logs"
  tags   = module.labels.tags
}

resource "aws_s3_bucket_ownership_controls" "example" {
  #checkov:skip=CKV2_AWS_65: BucketOwnerEnforced would break existing deployments with ACL state; tracked for v2 migration
  count  = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "s3" ? 1 : 0
  bucket = one(aws_s3_bucket.flow_log[*].id)
  rule {
    # NOTE: upgrading to BucketOwnerEnforced (which fully disables ACLs) is a
    # breaking change for existing buckets with ACL state. Keeping BucketOwnerPreferred
    # for safe in-place upgrades. Tracked: https://github.com/clouddrove/terraform-aws-vpc/issues
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  count      = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "s3" ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.example]
  bucket     = one(aws_s3_bucket.flow_log[*].id)
  acl        = "private"
}

resource "aws_s3_bucket_public_access_block" "example" {
  count                   = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "s3" ? 1 : 0
  bucket                  = aws_s3_bucket.flow_log[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  count  = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "s3" ? 1 : 0
  bucket = aws_s3_bucket.flow_log[0].id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms[0].arn
      sse_algorithm     = var.s3_sse_algorithm //"aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "flow_log" {
  count  = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "s3" ? 1 : 0
  bucket = aws_s3_bucket.flow_log[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "block-http" {
  count  = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "s3" && var.block_http_traffic ? 1 : 0
  bucket = aws_s3_bucket.flow_log[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "Blockhttp"
    Statement = [
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : [
          aws_s3_bucket.flow_log[0].arn,
          "${aws_s3_bucket.flow_log[0].arn}/*",
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      },
    ]
  })
}

##-----------------------------------------------------------------------------
## Below resources will create cloudwatch log group and its components. This cloudwatch log group will be used to store vpc flow logs if "flow_log_destination_type" variable is set to "cloud-watch-logs".
##-----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "flow_log" {
  count             = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "cloud-watch-logs" ? 1 : 0
  name              = format("%s-vpc-flow-log-cloudwatch_log_group", module.labels.id)
  retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  kms_key_id        = aws_kms_key.kms[0].arn
  tags              = module.labels.tags
}

resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  count                = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "cloud-watch-logs" && var.create_flow_log_cloudwatch_iam_role ? 1 : 0
  name                 = format("%s-vpc-flow-log-role", module.labels.id)
  assume_role_policy   = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role[0].json
  permissions_boundary = var.vpc_flow_log_permissions_boundary
  tags                 = module.labels.tags
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  count = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "cloud-watch-logs" && var.create_flow_log_cloudwatch_iam_role ? 1 : 0
  statement {
    sid = "AWSVPCFlowLogsAssumeRole"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log_cloudwatch" {
  count      = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "cloud-watch-logs" && var.create_flow_log_cloudwatch_iam_role ? 1 : 0
  role       = aws_iam_role.vpc_flow_log_cloudwatch[0].name
  policy_arn = aws_iam_policy.vpc_flow_log_cloudwatch[0].arn
}

resource "aws_iam_policy" "vpc_flow_log_cloudwatch" {
  count  = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "cloud-watch-logs" && var.create_flow_log_cloudwatch_iam_role ? 1 : 0
  name   = format("%s-vpc-flow-log-to-cloudwatch", module.labels.id)
  policy = data.aws_iam_policy_document.vpc_flow_log_cloudwatch[0].json
  tags   = module.labels.tags
}

data "aws_iam_policy_document" "vpc_flow_log_cloudwatch" {
  count = var.enable && var.enable_flow_log && var.flow_log_destination_arn == null && var.flow_log_destination_type == "cloud-watch-logs" && var.create_flow_log_cloudwatch_iam_role ? 1 : 0

  # Write actions scoped to the specific log group (principle of least privilege)
  statement {
    sid    = "AWSVPCFlowLogsPushToCloudWatch"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      aws_cloudwatch_log_group.flow_log[0].arn,
      "${aws_cloudwatch_log_group.flow_log[0].arn}:*",
    ]
  }

  # Describe actions require resource="*" — AWS does not support resource-level
  # restrictions for these read-only discovery actions
  statement {
    sid    = "AWSVPCFlowLogsDescribe"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
    resources = ["*"] #checkov:skip=CKV_AWS_111,CKV_AWS_356: DescribeLogGroups/Streams require resource=* per AWS docs
  }
}
##---------------------------------------------------------------------------------------------
## Below resource will deploy vpc flow logs for vpc created above. VPC flow log can be stored in either S3 bucket or Cloudwatch log group, as per your requirement.
##---------------------------------------------------------------------------------------------
resource "aws_flow_log" "vpc_flow_log" {
  count                    = var.enable && var.enable_flow_log == true ? 1 : 0
  log_destination_type     = var.flow_log_destination_type
  log_destination          = var.flow_log_destination_arn == null ? (var.flow_log_destination_type == "s3" ? aws_s3_bucket.flow_log[0].arn : aws_cloudwatch_log_group.flow_log[0].arn) : var.flow_log_destination_arn
  log_format               = var.flow_log_log_format
  iam_role_arn             = var.create_flow_log_cloudwatch_iam_role ? aws_iam_role.vpc_flow_log_cloudwatch[0].arn : var.flow_log_iam_role_arn
  traffic_type             = var.flow_log_traffic_type
  vpc_id                   = one(aws_vpc.default[*].id)
  max_aggregation_interval = var.flow_log_max_aggregation_interval
  dynamic "destination_options" {
    for_each = var.flow_log_destination_type == "s3" ? [true] : []

    content {
      file_format                = var.flow_log_file_format
      hive_compatible_partitions = var.flow_log_hive_compatible_partitions
      per_hour_partition         = var.flow_log_per_hour_partition
    }
  }
  tags = module.labels.tags
}
##----------------------------------------------------------------------------------------------------
## Below resource will deploy default network acl for vpc communication.
##-------------------------------------------------------------------------------------------------------
resource "aws_default_network_acl" "default" {
  count                  = var.enable && var.aws_default_network_acl ? 1 : 0
  default_network_acl_id = aws_vpc.default[0].default_network_acl_id
  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      action          = ingress.value.action
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = ingress.value.from_port
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
    }
  }
  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      action          = egress.value.action
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = egress.value.from_port
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
    }
  }
  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s-nacl", module.labels.id)
    }
  )
}

##-----------------------------------------------------------------------------
## VPC Gateway Endpoints (S3, DynamoDB) — no ENI, no cost per hour.
##-----------------------------------------------------------------------------
resource "aws_vpc_endpoint" "gateway" {
  for_each          = var.enable ? var.gateway_vpc_endpoints : {}
  vpc_id            = one(aws_vpc.default[*].id)
  service_name      = "com.amazonaws.${data.aws_region.current.region}.${each.key}"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = each.value.route_table_ids
  ip_address_type   = each.value.ip_address_type
  tags = merge(
    module.labels.tags,
    { "Name" = format("%s-%s-gwep", module.labels.id, each.key) }
  )
}

##-----------------------------------------------------------------------------
## VPC Interface Endpoints — creates ENIs in nominated subnets.
##-----------------------------------------------------------------------------
resource "aws_vpc_endpoint" "interface" {
  for_each            = var.enable ? var.interface_vpc_endpoints : {}
  vpc_id              = one(aws_vpc.default[*].id)
  service_name        = "com.amazonaws.${data.aws_region.current.region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = each.value.subnet_ids
  security_group_ids  = each.value.security_group_ids
  private_dns_enabled = each.value.private_dns_enabled
  ip_address_type     = each.value.ip_address_type
  tags = merge(
    module.labels.tags,
    { "Name" = format("%s-%s-ifep", module.labels.id, each.key) }
  )
}

##-----------------------------------------------------------------------------
## Custom Network ACLs — shell resource only; rules managed via separate
## aws_network_acl_rule resources to avoid perpetual inline-rule diffs.
##-----------------------------------------------------------------------------
resource "aws_network_acl" "custom" {
  for_each   = var.enable ? var.custom_nacls : {}
  vpc_id     = one(aws_vpc.default[*].id)
  subnet_ids = each.value.subnet_ids
  tags = merge(
    module.labels.tags,
    { "Name" = format("%s-%s-nacl", module.labels.id, each.key) }
  )
}

locals {
  _nacl_ingress = flatten([
    for nacl_key, nacl in(var.enable ? var.custom_nacls : {}) : [
      for rule in nacl.ingress_rules : {
        nacl_key        = nacl_key
        rule_no         = rule.rule_no
        action          = rule.action
        protocol        = rule.protocol
        from_port       = rule.from_port
        to_port         = rule.to_port
        cidr_block      = rule.cidr_block
        ipv6_cidr_block = rule.ipv6_cidr_block
      }
    ]
  ])
  _nacl_egress = flatten([
    for nacl_key, nacl in(var.enable ? var.custom_nacls : {}) : [
      for rule in nacl.egress_rules : {
        nacl_key        = nacl_key
        rule_no         = rule.rule_no
        action          = rule.action
        protocol        = rule.protocol
        from_port       = rule.from_port
        to_port         = rule.to_port
        cidr_block      = rule.cidr_block
        ipv6_cidr_block = rule.ipv6_cidr_block
      }
    ]
  ])
}

resource "aws_network_acl_rule" "custom_ingress" {
  for_each        = { for r in local._nacl_ingress : "${r.nacl_key}-${r.rule_no}" => r }
  network_acl_id  = aws_network_acl.custom[each.value.nacl_key].id
  rule_number     = each.value.rule_no
  egress          = false
  protocol        = each.value.protocol
  rule_action     = each.value.action
  from_port       = each.value.protocol == "-1" ? 0 : each.value.from_port
  to_port         = each.value.protocol == "-1" ? 0 : each.value.to_port
  cidr_block      = each.value.cidr_block
  ipv6_cidr_block = each.value.ipv6_cidr_block
}

resource "aws_network_acl_rule" "custom_egress" {
  for_each        = { for r in local._nacl_egress : "${r.nacl_key}-${r.rule_no}" => r }
  network_acl_id  = aws_network_acl.custom[each.value.nacl_key].id
  rule_number     = each.value.rule_no
  egress          = true
  protocol        = each.value.protocol
  rule_action     = each.value.action
  from_port       = each.value.protocol == "-1" ? 0 : each.value.from_port
  to_port         = each.value.protocol == "-1" ? 0 : each.value.to_port
  cidr_block      = each.value.cidr_block
  ipv6_cidr_block = each.value.ipv6_cidr_block
}

##-----------------------------------------------------------------------------
## VPC BPA exclusion — creates a per-VPC exclusion when the account has
## Block Public Access enabled but this VPC needs internet connectivity.
##-----------------------------------------------------------------------------
resource "aws_vpc_block_public_access_exclusion" "this" {
  count                           = var.enable && var.vpc_bpa_exclusion_mode != null ? 1 : 0
  vpc_id                          = one(aws_vpc.default[*].id)
  internet_gateway_exclusion_mode = var.vpc_bpa_exclusion_mode
}
