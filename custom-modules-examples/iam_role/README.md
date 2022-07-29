IAM Role Module
===========

This module will create an IAM Role with a trust policy based on a service name. It will not be created with any policies

Required Input Variables
----------------------

- `service` - Specify the name of an AWS Service to be added to the trust policy
- `role_name` - Specify the IAM Role name to be created

Optional Input Variables
----------------------

- None

Usage
-----

```hcl
module "iam_role" {
  source = "./modules/iam_role"

  service   = "ec2"
  role_name = "use1_dev_ec2_servers"
}
```

Outputs
----------------------

- `arn` - The ARN of the IAM Role
- `name` - The Name of the IAM Role

Authors
----------------------

mlynch1985@gmail.com
