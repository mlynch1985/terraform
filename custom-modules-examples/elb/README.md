# Elastic Load Balancer Module

This module creates an Elastic Load Balancer without any Listener nor Target Groups associated.

---

## Input Variables

| Name | Type | Required | Default | Description |
| ---- | ---- | -------- | ------- | ----------- |
| `bucket_name` | String | No | `null` | Specify a S3 Bucket Name if you would like to enable ELB Access Logs to be enabled |
| `drop_invalid_header_fields` | Boolean | No | `false` | For ALBs only, set to `true` to enable this feature |
| `enable_cross_zone_load_balancing` | Boolean | No | `false` | For NLBs only, set to `true` to enable this feature |
| `idle_timeout` | Number | No | `null` | For ALBs only, specify a connection timeout in seconds (Allowed Values: 10-300) |
| `is_internal` | Boolean | Yes | `false` | Set to `true` if you would like to provision this ELB in private subnets only |
| `lb_type` | String | Yes | N/A | Select which type of ELB to deploy (Allowed Values: `application` \| `network` \| `gateway`) |
| `listeners` | map(Object) | No | `{}` | Provide a map of ELB Listener Objects to attach to the ELB. [See Below](#listeners) |
| `name_tag` | String | No | `null` | Specify a Tag Value to add to the Name tag for the ELB |
| `security_groups` | list(String) | No | `[]` | For ALBs only, provide a list of Security Group IDs to be attached to the listener |
| `subnets` | list(String) | Yes | N/A | Provide a list of Subnet IDs to provision the ELB into |

---

### Listeners

```hcl
[{
  "alpn_policy"       = null | "HTTP1Only" | "HTTP2Only" | "HTTP2Optional" | "HTTP2Preferred" | "None"
  "certificate_arn"   = null
  "listener_port"     = 80 | null
  "listener_protocol" = "HTTP" | "HTTPS" | "TCP" | "TLS" | null
  "ssl_policy"        = null | "ELBSecurityPolicy-2016-08" | REFERENCE - https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies

  "default_action" = [{
    "action_type" = "forward" | "fixed-response" | "redirect"

    "fixed_response" = [{
      "content_type"      = null | "text/plain" | "text/css" | "text/html"
      "message_body"      = null
      "fixed_status_code" = null | 200-500
    }]

    "forward" = [{
      "target_group_arns"   = []
      "stickiness_duration" = 1-604800
      "enable_stickiness"   = true | false
    }]

    "redirect" = [{
      "redirect_status_code" = "HTTP_301" | "HTTP_302"
      "redirect_host"        = null | "#{host}"
      "redirect_path"        = null | "#{path}" | "/"
      "redirect_port"        = null | "#{port}" | 1-65535
      "redirect_protocol"    = null | "#{protocol}" | "HTTP" | "HTTPS"
    }]
  }]
}]

```

## Output Variables

| Name | Resource Type | Description |
| ---- | ------------- | ----------- |
| `id` | [Load Balancer ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#id) | The `ID` of the new Load Balancer |
| `arn` | [Load Balancer ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn) | The `ARN` of the new Load Balancer |
| `name` | [Load Balancer Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#name) | The `Name` of the new Load Balancer |
| `dns_name` | [Load Balancer DNS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name) | The `DNS` of the new Load Balancer |

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

  listeners = {
    "listener_1" = [
      "alpn_policy"       = null
      "certificate_arn"   = null
      "listener_port"     = 80
      "listener_protocol" = "HTTP"
      "ssl_policy"        = null

      "default_action" = [{
        "action_type" = "forward"

        "forward" = [{
          "target_group_arns"   = [TBD]
          "stickiness_duration" = 3600
          "enable_stickiness"   = true
        }]
      }]
    ]
  },
    "listener_2" = [
      "alpn_policy"       = null
      "certificate_arn"   = null
      "listener_port"     = 81
      "listener_protocol" = "HTTP"
      "ssl_policy"        = null

      "default_action" = [{
        "action_type" = "fixed-response"

        "fixed_response" = [{
          "content_type"      = "text/plain"
          "message_body"      = "Hello World!"
          "fixed_status_code" = 200
        }]
      }]
    ]
  },
    "listener_3" = [
      "alpn_policy"       = null
      "certificate_arn"   = null
      "listener_port"     = 82
      "listener_protocol" = "HTTP"
      "ssl_policy"        = null

      "default_action" = [{
        "action_type" = "redirect"

        "redirect" = [{
          "redirect_status_code" = "HTTP_302"
          "redirect_host"        = "#{host}"
          "redirect_path"        = "#{path}/app"
          "redirect_port"        = "#{port}"
          "redirect_protocol"    = "#{protocol}"
        }]
      }]
    ]
  },
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
