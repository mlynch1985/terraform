AWS Terraform Examples
===========

This repository contains Terraform code snippets that can be reused and applied to varrying AWS deployments. It provides a starting point to launching new complex applications using Terraform.

Prerequisites
----------------------

- `AWS CLI` - Install the latest [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) version for your operating system.
- `GIT` - Install the latest version of [GIT](https://git-scm.com/downloads) for your operating system.
- `VS Code` - Install the latest verion of [VS Code](https://code.visualstudio.com/download) for your operating systems.

Configure Environment
----------------------

```bash
# Configure AWS CLI Profile
aws configure --profile sandbox

# Configure Default Region
export AWS_DEFUAULT_REGION="us-east-1"

# Set Current Session Profile
export AWS_PROFILE="sandbox"

# Configure Default Profile
export AWS_DEFAULT_PROFILE="sandbox"

# Configure Proxy Server
export HTTPS_PROXY="proxy.example.com:8443"

# Setup AWS SSO Login Profiles
# Ref: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html
aws configure sso
aws sso login --profile sandbox
aws sso logout

# Setup Okta SAML Login
# Ref: https://github.com/Versent/saml2aws
saml2aws configure --idp-provider=Okta --mfa=PUSH --username=developer --url https://sandbox.okta.com/ --skip-prompt
saml2aws login
```

Deployment
----------------------

- Open VS Code and set your default shell to `bash`.
- Configure Github [ssh credentials](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/connecting-to-github-with-ssh)
- Clone this repository to your local computer
- Switch into the cloned repository folder of the stack you wish to deploy
- Create or update the .tfvars to include the required parameters
- Refernce the below commands to deploy your stack

```bash
# Initialize your environment first
terraform init

# Review the proposed changes and fix errors when needed
terraform plan -var-file="./useast1d.tfvars"

# Deploy the proposed changes into your AWS Account
terraform apply -var-file="./useast1d.tfvars"

# Remove the stack from your AWS Account
terraform destroy -var-file="./useast1d.tfvars"
```

Authors
----------------------

awsml@amazon.com
