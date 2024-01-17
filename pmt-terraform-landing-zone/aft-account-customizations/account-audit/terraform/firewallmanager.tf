# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_wafregional_rule_group" "region1" {
  metric_name = "WAFRuleGroupExample"
  name        = "WAF-Rule-Group-Example"
  provider    = aws.region1
}

resource "aws_wafregional_rule_group" "region2" {
  metric_name = "WAFRuleGroupExample"
  name        = "WAF-Rule-Group-Example"
  provider    = aws.region2
}


resource "aws_fms_policy" "region1" {
  name                  = "FMS-Policy-Example"
  exclude_resource_tags = false
  remediation_enabled   = false
  resource_type         = "AWS::ElasticLoadBalancingV2::LoadBalancer"

  security_service_policy_data {
    type = "WAF"

    managed_service_data = jsonencode({
      type = "WAF",
      ruleGroups = [{
        id = aws_wafregional_rule_group.region1.id
        overrideAction = {
          type = "COUNT"
        }
      }]
      defaultAction = {
        type = "BLOCK"
      }
      overrideCustomerWebACLAssociation = false
    })
  }
  provider = aws.region1
}

resource "aws_fms_policy" "region2" {
  name                  = "FMS-Policy-Example"
  exclude_resource_tags = false
  remediation_enabled   = false
  resource_type         = "AWS::ElasticLoadBalancingV2::LoadBalancer"

  security_service_policy_data {
    type = "WAF"

    managed_service_data = jsonencode({
      type = "WAF",
      ruleGroups = [{
        id = aws_wafregional_rule_group.region2.id
        overrideAction = {
          type = "COUNT"
        }
      }]
      defaultAction = {
        type = "BLOCK"
      }
      overrideCustomerWebACLAssociation = false
    })
  }
  provider = aws.region2
}
