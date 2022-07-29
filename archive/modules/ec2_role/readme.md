EC2 IAM Role Module
===========

A Terraform module that will deploy an IAM Role and EC2 Instance Profile with permisisons to AWS Systems Manager (SSM), Cloudwatch, S3 and Secrets Manager restricted to a namespace and app role.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `component` - Specify the application role for this IAM Role.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB resources. Defaults to `{}`.
- `path` - Specify the path to create this role. Defaults to `"/"`.
- `description` - Give this IAM role a friendly description. Defaults to `""`.
- `max_session_duration` - Provide the number of seconds to allow sessions to last. Defaults to `3600`.

Usage
-----

```hcl
module "ec2_role" {
  source = "../modules/ec2_role"

  namespace            = "useast1d"
  component             = "appdemo1"
  path                 = "/"
  description          = ""
  max_session_duration = 3600

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

- `role` - Outputs the [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) object.
- `profile` - Outputs the [aws_iam_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) object.

Authors
----------------------

mlynch1985@gmail.com
