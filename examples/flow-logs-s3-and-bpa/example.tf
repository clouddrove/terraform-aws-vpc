provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../.."

  name        = "vpc-secure"
  environment = "prod"
  cidr_block  = "10.20.0.0/16"

  # VPC Flow Logs to KMS-Encrypted S3 Bucket
  enable_flow_log                  = true
  flow_log_destination_type        = "s3"
  flow_log_traffic_type            = "ALL"
  flow_log_file_format             = "parquet"
  flow_log_hive_compatible_partitions = true
  block_http_traffic               = true

  # Allow Internet Gateway access when account-level VPC Block Public Access is enabled
  vpc_bpa_exclusion_mode = "allow-bidirectional"
}
