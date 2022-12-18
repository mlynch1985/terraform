# IAM Role Module

This module creates an IAM Role and an IAM Instance Profile.

---

## Input Variables

| Name | Type | Required | Default | Description |
| ---- | ---- | -------- | ------- | ----------- |
| `inline_policy_json` | list(Object) | No | `[]` | Provide a list of IAM Inline Policy Objects to attach to this role |
| `managed_policy_arns` | list(String) | No | `[]` | Provide a list of Manged IAM Policy ARNs to attach to this role |
| `role_name` | string | No | `null` | Provide a short name to be used as the IAM Role Name Prefix |
| `service` | string | Yes | N/A | Provide the AWS Service Name prefix excluding the "amazonaws.com" domain to be used in the Trust Policy |

---

## Output Variables

| Name | Resource Type | Description |
| ---- | ------------- | ----------- |
| `id` | [IAM Role ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#id) | The `ID` of the new IAM Role |
| `arn` | [IAM Role ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn) | The `ARN` of the new IAM Role |
| `name` | [IAM Role Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#name) | The `Name` of the new IAM Role |
| `profile` | [IAM Instance Profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile#name) | The `Name` of the new IAM Instance Profile |

---

## Usage

```hcl
module "iam_role" {
  source = "./modules/iam_role"

  inline_policy_json = [
    {
      Version = "2012-10-17"
      Statement = [{
        Sid    = "GrantS3ReadOnly"
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Resource   = ["*"]
        Conditions = []
      }]
    },
    {
      Version = "2012-10-17"
      Statement = [{
        Sid    = "GrantCloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource   = ["*"]
        Conditions = []
      }]
    }
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]

  role_name = "iam_role_tester"
  service   = "ec2"
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
