variable "vpcName" {
  type        = string
  description = "s3name."
}

variable "awsRegion" {
  type = string
  description = "region"
}

variable "access_key" {
  type = string
  description = "Secret Access key for AWS Account."
}

variable "secret_key" {
  type = string
  description = "Access key for AWS Account."
}