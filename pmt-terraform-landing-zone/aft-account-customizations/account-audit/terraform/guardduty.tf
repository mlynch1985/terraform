# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.


### After executing the CT Management Pipeline, go to the GuardDuty console in each region and enable the "Permissions" checkbox prior to running the Audit Account Pipeline ###
data "aws_guardduty_detector" "region1" {
  provider = aws.region1
}

data "aws_guardduty_detector" "region2" {
  provider = aws.region2
}


resource "aws_guardduty_organization_configuration" "region1" {
  auto_enable_organization_members = "ALL" # ALL | NEW | NONE

  detector_id = data.aws_guardduty_detector.region1.id

  datasources {
    s3_logs {
      auto_enable = true
    }
    kubernetes {
      audit_logs {
        enable = true
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = true
        }
      }
    }
  }

  provider = aws.region1
}


resource "aws_guardduty_organization_configuration" "region2" {
  auto_enable_organization_members = "ALL" # ALL | NEW | NONE

  detector_id = data.aws_guardduty_detector.region2.id

  datasources {
    s3_logs {
      auto_enable = true
    }
    kubernetes {
      audit_logs {
        enable = true
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = true
        }
      }
    }
  }

  provider = aws.region2
}
