# IAM Role Module

This module creates an IAM Role and an IAM Instance Profile.

---

## Required Input Variables

- `role_name` - Specify a name prefix for the IAM Role.
- `service` - Specify the AWS Service name prefix without the \".amazonaws.com\" domain.

---

## Optional Input Variables

- `inline_policy_json` - Provide a JSON IAM Policy to attach to this role.
- `managed_policy_arns` - Provide a list of managed IAM policies ARNs to attach to this role.

---

## Usage

```hcl
module "iam_role" {
  source = "./modules/iam_role"

  # Required Parameters
  role_name = "${var.namespace}_${var.environment}_ec2"
  service   = "ec2"

  # Optional Parameters
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  inline_policy_json = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-bucket/*"
    }
  ]
}
EOF
}
```

---

## Outputs

- `id` - The IAM Role [ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#id)
- `arn` - The IAM Role [ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#arn)
- `name` - The IAM Role [Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#name)
- `profile` - The IAM Instance Profile [ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile#arn)

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
