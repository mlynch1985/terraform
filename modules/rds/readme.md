AWS RDS Module
===========

A Terraform module that will deploy an AWS RDS Aurora Cluster using the MySQL driver.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `component` - Specify the application role for this instance.
- `subnets` - Provide a list of subnet IDs of where each mount point should be deployed.
- `availability_zones` - Provide a list(string) of availability zone names. Max=`3`
- `security_groups` - Provide a list(string) of security group IDs to associate with this instance.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB resources. Defaults to `{}`.

Usage
-----

```hcl
module "rds" {
  source = "../modules/rds"

  namespace          = "useast1d"
  component           = "appdemo1"
  subnets            = data.aws_subnet_ids.private.ids
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  security_groups    = ["sg-1a2b3c4d5e", "subnet-6f7g8h9i0k"]

  default_tags = {
    namespace: "useast1d"
    component: "appdemo01"
    lob: "business"
    team: "operations"
    environemnt: "developement"
  }
}
```

Outputs
----------------------

- `None`

Authors
----------------------

awsml@amazon.com
