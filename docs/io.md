## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_cidr\_block | List of secondary CIDR blocks of the VPC. | `list(string)` | `[]` | no |
| assign\_generated\_ipv6\_cidr\_block | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Conflicts with ipv6\_ipam\_pool\_id | `bool` | `true` | no |
| aws\_default\_network\_acl | A boolean flag to enable/disable Default Network acl in the VPC. | `bool` | `true` | no |
| aws\_default\_route\_table | A boolean flag to enable/disable Default Route Table in the VPC. | `bool` | `true` | no |
| block\_http\_traffic | True when http traffic has to be blocked for S3. | `bool` | `true` | no |
| cidr\_block | CIDR for the VPC. | `string` | `""` | no |
| create\_flow\_log\_cloudwatch\_iam\_role | Flag to be set true when cloudwatch iam role is to be created when flow log destination type is set to cloudwatch logs. | `bool` | `false` | no |
| default\_network\_acl\_egress | List of maps of egress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| default\_network\_acl\_ingress | List of maps of ingress rules to set on the Default Network ACL | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  },<br>  {<br>    "action": "allow",<br>    "from_port": 0,<br>    "ipv6_cidr_block": "::/0",<br>    "protocol": "-1",<br>    "rule_no": 101,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| default\_route\_table\_routes | Configuration block of routes. | `list(map(string))` | `[]` | no |
| default\_security\_group\_egress | List of maps of egress rules to set on the default security group | `list(map(string))` | `[]` | no |
| default\_security\_group\_ingress | List of maps of ingress rules to set on the default security group | `list(map(string))` | `[]` | no |
| dhcp\_options\_domain\_name | Specifies DNS name for DHCP options set (requires enable\_dhcp\_options set to true) | `string` | `"service.consul"` | no |
| dhcp\_options\_domain\_name\_servers | Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable\_dhcp\_options set to true) | `list(string)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |
| dhcp\_options\_netbios\_name\_servers | Specify a list of netbios servers for DHCP options set (requires enable\_dhcp\_options set to true) | `list(string)` | `[]` | no |
| dhcp\_options\_netbios\_node\_type | Specify netbios node\_type for DHCP options set (requires enable\_dhcp\_options set to true) | `string` | `""` | no |
| dhcp\_options\_ntp\_servers | Specify a list of NTP servers for DHCP options set (requires enable\_dhcp\_options set to true) | `list(string)` | `[]` | no |
| dns\_hostnames\_enabled | A boolean flag to enable/disable DNS hostnames in the VPC. | `bool` | `true` | no |
| dns\_support\_enabled | A boolean flag to enable/disable DNS support in the VPC. | `bool` | `true` | no |
| enable | Flag to control the vpc creation. | `bool` | `true` | no |
| enable\_dhcp\_options | Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type | `bool` | `false` | no |
| enable\_flow\_log | Enable vpc\_flow\_log logs. | `bool` | `false` | no |
| enable\_key\_rotation | Specifies whether key rotation is enabled. Defaults to true(security best practice) | `bool` | `true` | no |
| enable\_network\_address\_usage\_metrics | Determines whether network address usage metrics are enabled for the VPC | `bool` | `null` | no |
| enabled\_ipv6\_egress\_only\_internet\_gateway | A boolean flag to enable/disable IPv6 Egress-Only Internet Gateway creation | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| flow\_log\_cloudwatch\_log\_group\_retention\_in\_days | Specifies the number of days you want to retain log events in the specified log group for VPC flow logs | `number` | `null` | no |
| flow\_log\_destination\_arn | ARN of destination where vpc flow logs are to stored. Can be of existing s3 or existing cloudwatch log group. | `string` | `null` | no |
| flow\_log\_destination\_type | Type of flow log destination. Can be s3 or cloud-watch-logs | `string` | `"cloud-watch-logs"` | no |
| flow\_log\_file\_format | (Optional) The format for the flow log. Valid values: `plain-text`, `parquet` | `string` | `null` | no |
| flow\_log\_hive\_compatible\_partitions | (Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3 | `bool` | `false` | no |
| flow\_log\_iam\_role\_arn | The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow\_log\_destination\_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided | `string` | `null` | no |
| flow\_log\_log\_format | The fields to include in the flow log record, in the order in which they should appear | `string` | `null` | no |
| flow\_log\_max\_aggregation\_interval | The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds | `number` | `600` | no |
| flow\_log\_per\_hour\_partition | (Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries | `bool` | `false` | no |
| flow\_log\_traffic\_type | The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL | `string` | `"ALL"` | no |
| flow\_logs\_bucket\_name | Name  (e.g. `mybucket` or `bucket101`). | `string` | `null` | no |
| instance\_tenancy | A tenancy option for instances launched into the VPC. | `string` | `"default"` | no |
| ipam\_pool\_enable | Flag to be set true when using ipam for cidr. | `bool` | `false` | no |
| ipv4\_ipam\_pool\_id | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | `string` | `""` | no |
| ipv4\_netmask\_length | The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv4\_ipam\_pool\_id | `string` | `null` | no |
| ipv6\_cidr\_block | IPv6 CIDR for the VPC. | `string` | `null` | no |
| ipv6\_cidr\_block\_network\_border\_group | Set this to restrict advertisement of public addresses to a specific Network Border Group such as a LocalZone. | `string` | `null` | no |
| ipv6\_ipam\_pool\_id | The ID of an IPv6 IPAM pool you want to use for allocating this VPC's CIDR. | `string` | `null` | no |
| ipv6\_netmask\_length | The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv6\_ipam\_pool\_id | `string` | `null` | no |
| kms\_key\_deletion\_window | KMS Key deletion window in days. | `number` | `10` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| managedby | ManagedBy, eg 'CloudDrove' | `string` | `"hello@clouddrove.com"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-vpc"` | no |
| restrict\_default\_sg | Flag to control the restrict default sg creation. | `bool` | `true` | no |
| s3\_sse\_algorithm | Server-side encryption algorithm to use. Valid values are AES256 and aws:kms | `string` | `"aws:kms"` | no |
| vpc\_flow\_log\_permissions\_boundary | The ARN of the Permissions Boundary for the VPC Flow Log IAM Role | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name (ARN) of VPC |
| igw\_id | The ID of the Internet Gateway. |
| ipv6\_cidr\_block | The IPv6 CIDR block. |
| ipv6\_cidr\_block\_network\_border\_group | The IPv6 Network Border Group Zone name |
| ipv6\_egress\_only\_igw\_id | The ID of the egress-only Internet Gateway |
| tags | A mapping of tags to assign to the resource. |
| vpc\_arn | The ARN of the VPC |
| vpc\_cidr\_block | The CIDR block of the VPC. |
| vpc\_default\_network\_acl\_id | The ID of the network ACL created by default on VPC creation. |
| vpc\_default\_route\_table\_id | The ID of the route table created by default on VPC creation. |
| vpc\_default\_security\_group\_id | The ID of the security group created by default on VPC creation. |
| vpc\_id | The ID of the VPC. |
| vpc\_ipv6\_association\_id | The association ID for the IPv6 CIDR block. |
| vpc\_main\_route\_table\_id | The ID of the main route table associated with this VPC. |
