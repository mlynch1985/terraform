# Elastic Load Balancer Module

This module creates an Elastic Load Balancer without any Listener nor Target Groups associated.

---

## Required Input Variables

- `is_internal` - Set to `true` if this is a private ELB or `false` if its public facing.
- `lb_type` - Specify the type of load balancer to deploy.
- `name` - Specify the ELB name prefix.
- `subnets` - List of subnet IDs to deploy the ELB into.

---

## Optional Input Variables

- `bucket_name` - Specify a S3 Bucket Name to receive access logs. Defaults to `""`.
- `drop_invalid_header_fields` - Set to `true` to drop invalid headers for ALB only. Defaults to `true`.
- `enable_access_logs` - Set to `true` to enable access logs to sent to the S3 bucket. Defaults to `false`.
- `enable_cross_zone_load_balancing` - Specify the amount of seconds before timing out idle connections. Defaults to `60`.
- `security_groups` - Provide a list of security group IDs to attach to an ALB. Defaults to `[]`.

- `listeners` - Specify a list of listener maps to create. Defaults to `[]`.

---

## Output Variables

- `id` - The Load Balancer [ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#id)
- `arn` - The Load Balancer [ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn)
- `name` - The Load Balancer [Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#name)
- `dns_name` - The Load Balancer [DNS Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name)

---

## Usage

```hcl
module "elb" {
  source = "./modules/elb"

  # Required Parameters
  is_internal = false
  lb_type     = "application"
  name        = "app1"
  subnets     = ["subnet-1a2b3c4d5e", "subnet-6f7g8h9i0k"]

  # Optional Parameters
  bucket_name                      = "app1-access-logs"
  drop_invalid_header_fields       = true
  enable_access_logs               = true
  enable_cross_zone_load_balancing = null
  security_groups                  = ["sg-1a2b3c4d5e", "sg-6f7g8h9i0k"]

  listeners = [
    {
      certificate_arn = ""
      listener_port     = 80
      listener_protocol = "HTTP" # HTTP|HTTPS|TCP|TLS
      ssl_policy        = "" # HTTPS|TLS

      default_action = {
        action_type = "fixed-response" # fixed-response|forward|redirect

        fixed_response = [{
          content_type      = "text/plain" # text/plain | text/css | text/html
          fixed_status_code = 200 # 200-500
          message_body      = "Hello World!"
        }]

        forward = [{
          enable_stickiness   = null
          stickiness_duration = 0
          target_group_arn    = ""
          target_group_weight = 0
        }]

        redirect = [{
          redirect_host        = "" # #{host}
          redirect_path        = ""
          redirect_port        = 0 # #{port}
          redirect_protocol    = "" # HTTP|HTTPS|#{protocol}
          redirect_status_code = "" # HTTP_301 | HTTP_302
        }]
      }
    }
  ]
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
