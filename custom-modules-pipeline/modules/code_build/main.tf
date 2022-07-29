resource "aws_codebuild_project" "codebuild" {
  name                   = var.codebuild_name
  service_role           = var.role_arn
  build_timeout          = 60
  concurrent_build_limit = 1

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "BUCKET_NAME"
      type  = "PLAINTEXT"
      value = var.bucket_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.codebuild_name
      status      = "ENABLED"
      stream_name = "codebuild"
    }
  }

  source {
    type      = "NO_SOURCE"
    buildspec = <<-EOF
version: 0.2

phases:
  install:
    runtime-versions:
      golang: latest
      python: latest

    commands:
      - echo "Installing Terraform... "
      - yum install -y yum-utils
      - yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
      - yum -y install terraform
      - terraform --version
      - echo "Install Complete!"

      - echo "Installing tflint... "
      - wget -O /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_amd64.zip
      - unzip /tmp/tflint.zip -d /usr/local/bin
      - rm /tmp/tflint.zip
      - echo "Install Complete!"

      - echo "Configuring tflint AWS Plugin... "
      - mkdir -p ~/.tflint.d/plugin
      - wget -O /tmp/tflint-ruleset-aws.zip https://github.com/terraform-linters/tflint-ruleset-aws/releases/latest/download/tflint-ruleset-aws_linux_amd64.zip
      - unzip /tmp/tflint-ruleset-aws.zip -d ~/.tflint.d/plugins
      - tflint --init
      - rm /tmp/tflint-ruleset-aws.zip
      - echo "AWS Plugin Configuration Complete!"

      - echo "Installing tfsec... "
      - wget -O /tmp/tfsec-linux-amd64 https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-amd64
      - chmod a+x /tmp/tfsec-linux-amd64
      - echo "Install Complete!"

      - echo "Installing checkov... "
      - pip3 install -U checkov
      - echo "Install Complete!"

  build:
    commands:
      - echo "Initializing Terraform environment and begining tflint scan... "
      - terraform init
      - tflint --color --module
      - echo "tflint Scan Complete!"

      - echo "Executing tfsec scan"
      - |
        if [[ -f "terraform.tfvars" ]]
        then
          /tmp/tfsec-linux-amd64 . --tfvars-file terraform.tfvars
        else
          /tmp/tfsec-linux-amd64 .
        fi
      - echo "tfsec Scan Complete!"

      - echo "Executing checkov scan... "
      - checkov --directory .
      - echo "checkov Scan Complete!"

  post_build:
    commands:
      - echo "Loop through source code directory and create a zip file for each folder we discover"
      - |
        for DIRECTORY in *; do
          if [ -d "$DIRECTORY" ]; then
            echo $DIRECTORY
            zip -jr $DIRECTORY.zip $DIRECTORY/*
          fi
        done
      - echo "For each zip file that we just created, attempt to push to our S3 bucket"
      - aws s3 sync . s3://$BUCKET_NAME --exclude "*" --include "*.zip" --delete
EOF
  }
}
