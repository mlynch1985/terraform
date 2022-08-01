# Security Group Module

This module creates an EC2 Security Group within a specific VPC.

---

## Required Input Variables

- `group_name_prefix` - Specify a name to prefix the security group.
- `vpc_id` - Specify the VPC ID for this security group.

---

## Optional Input Variables

- `rules` - Specify a list of security group rule maps to attach. Default:

```hcl
[{
    cidr_blocks              = "0.0.0.0/0"
    description              = "default outbound rule"
    from_port                = "0"
    protocol                 = "-1"
    source_security_group_id = null
    to_port                  = "0"
    type                     = "egress"
}]
```

---

## Output Variables

- `id` - The Security Group [ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#id)
- `arn` - The Security Group [ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#arn)
- `name` - The Security Group Pool [ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#name)

---

## Usage

```hcl
module "security_group" {
  source = "./modules/security_group"

  # Required Parameters
  group_name_prefix = "use1d-ec2"
  vpc_id            = "vpc-1a2b3c4d5e6f7g8h9"

  # Optional Parameters
  rules = [
    {
      cidr_blocks              = "172.31.0.0/16"
      description              = "allow inbound http"
      from_port                = "80"
      protocol                 = "tcp"
      source_security_group_id = null
      to_port                  = "80"
      type                     = "ingress"
    },
    {
      cidr_blocks              = "0.0.0.0/0"
      description              = "default outbound rule"
      from_port                = "0"
      protocol                 = "-1"
      source_security_group_id = null
      to_port                  = "0"
      type                     = "egress"
    }
  ]
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
