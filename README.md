# Terraform Demo on AWS

## Description
This project will create a standard AWS VPC, a basic Wordpress site and RDS database using multiple CloudFormation Templates.  Over time it will include common components that should be used in Production-like environments to enhance your understanding of real life implementations.

## Prerequisites
- Install the [AWS ClI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) tools for your platform
- Install the [Isengard CLI tools](https://drive-render.corp.amazon.com/view/rizra@/Isengard-cli/docs/README.html#quickstart)
- Connect to your Isengard account

```bash
## List your current Isengard accounts
isengard ls

## Create temporary session credentials
isengard assume

## Open your web browser to the AWS Console
isengard open

## Examples
isengard assume awsml+terraform
isengard open awsml+terraform
```

## Deployment
- Switch into the root directory where you checked out this code
- Update the variables file for your environment

### Deploy Base first
```bash
$Env:AWS_SDK_LOAD_CONFIG="1"
cd "base"
terraform init
terraform apply -var-file="C:\Git\tf\useast1d.tfvars"
```

### Deploy Monitoring second
```bash
$Env:AWS_SDK_LOAD_CONFIG="1"
cd "..\monitoring"
terraform init
terraform apply -var-file="C:\Git\tf\useast1d.tfvars"
```

### Deploy Linux Jump
```bash
$Env:AWS_SDK_LOAD_CONFIG="1"
cd "..\linux-jump"
terraform init
terraform apply -var-file="C:\Git\tf\useast1d.tfvars"
```

### Deploy Windows Jump
```bash
$Env:AWS_SDK_LOAD_CONFIG="1"
cd "..\windows-jump"
terraform init
terraform apply -var-file="C:\Git\tf\useast1d.tfvars"
```

### Deploy Linux Wordpress
```bash
$Env:AWS_SDK_LOAD_CONFIG="1"
cd "..\linux-wordpress"
terraform init
terraform apply -var-file="C:\Git\tf\useast1d.tfvars"
```

## Remove each stack
```bash
cd "..\linux-wordpress"
terraform destroy -var-file="C:\Git\tf\useast1d.tfvars"

cd "..\linux-jump"
terraform destroy -var-file="C:\Git\tf\useast1d.tfvars"

cd "..\windows-jump"
terraform destroy -var-file="C:\Git\tf\useast1d.tfvars"

cd "..\monitoring"
terraform destroy -var-file="C:\Git\tf\useast1d.tfvars"

cd "..\base"
terraform destroy -var-file="C:\Git\tf\useast1d.tfvars"
```

## References
- [AWS ClI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [Isengard CLI tools](https://drive-render.corp.amazon.com/view/rizra@/Isengard-cli/docs/README.html#quickstart)
- [Cloudformation API](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/index.html)
