provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../.."

  name        = "vpc-endpoints"
  environment = "test"
  cidr_block  = "10.10.0.0/16"

  restrict_default_sg = true

  # Gateway Endpoints (Zero hourly cost)
  gateway_vpc_endpoints = {
    s3 = {
      route_table_ids = [] # Pass your private/public route table IDs
      ip_address_type = "ipv4"
    }
    dynamodb = {
      route_table_ids = []
      ip_address_type = "ipv4"
    }
  }

  # Custom Network ACLs
  custom_nacls = {
    private = {
      subnet_ids = [] # Pass your subnet IDs
      ingress_rules = [
        {
          rule_no         = 100
          action          = "allow"
          protocol        = "tcp"
          from_port       = 443
          to_port         = 443
          cidr_block      = "10.10.0.0/16"
          ipv6_cidr_block = null
        }
      ]
      egress_rules = [
        {
          rule_no         = 100
          action          = "allow"
          protocol        = "-1"
          from_port       = 0
          to_port         = 0
          cidr_block      = "0.0.0.0/0"
          ipv6_cidr_block = null
        }
      ]
    }
  }
}
