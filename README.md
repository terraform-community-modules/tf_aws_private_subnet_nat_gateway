# Private subnets with NAT Gateway in VPC Terraform Module
==========================================================

A Terraform module to create private subnets with NAT Gateway in VPC in AWS.

Make sure that you don't hit soft-limit of EIP per VPC.

If you want to create public and private subnets using single module you can use [tf_aws_vpc module](https://github.com/terraform-community-modules/tf_aws_vpc).


Module Input Variables
----------------------

- `name` - Name (optional)
- `vpc_id` - VPC id
- `cidrs` - List of private subnet CIDR blocks
- `azs` - List of availability zones
- `public_subnet_ids` - List of public subnet ids where NAT gateway will be created
- `nat_gateways_count` - Number of NAT gateways to create (should be at least 1). For high-availability make it equal to public subnets.
- `map_public_ip_on_launch` - Boolean that controls the subnets ability to assign public ip addresses (default=true).
- `tags` - dictionary of tags that will be added to resources created by the module

Usage
-----

```js
module "private_subnet" {
  source             = "github.com/terraform-community-modules/tf_aws_private_subnet_nat_gateway"

  name               = "production-private"
  vpc_id             = "vpc-12345678"
  cidrs              = ["10.4.1.0/24", "10.4.2.0/24", "10.4.3.0/24"]
  azs                = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnet_ids  = ["subnet-123abcde", "subnet-456abcde", "subnet-789abcde"]
  nat_gateways_count = 3    # can be between 1 and "number of public subnets".

  tags {
      "Terraform" = "true"
      "Environment" = "${var.environment}"
  }
}
```

Outputs
=======

- `subnet_ids` - List of private subnet ids
- `private_route_table_ids` - List of route table ids
- `nat_eips` - List of NAT gateways EIPs

Authors
=======

Originally created and maintained by [Anton Babenko](https://github.com/antonbabenko).

License
=======

Apache 2 Licensed. See LICENSE for full details.
