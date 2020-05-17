<# ## Terraform Setup Guide ## #>

## Download the latest Terraform .exe and copy it to your C:\Windows\System32\ folder

## Define Environment Variables
$Env:AWS_SDK_LOAD_CONFIG="1"
$Env:AWS_DEFAULT_PROFILE="AdminRole"
$Env:HTTPS_PROXY="myproxy.home.com:81"

## Set the correct region to target
aws configure set region us-east-1

## Initialize and apply each stack
$Stack = "base-network"
$Namespace = "useast1d"
cd "C:\Git\tf\$Stack"
terraform init ## -backend-config="$($Namespace).tfvars"
terraform apply -var-file="C:\Git\tf\$($Namespace).tfvars"

## Remove broken local state file
Remove-Item -Path .terraform/terraform.tfstate

$Env:AWS_SDK_LOAD_CONFIG="1"
cd "C:\Git\tf\base"
terraform apply -var-file="C:\Git\tf\useast1d.tfvars"

$Env:AWS_SDK_LOAD_CONFIG="1"
cd "C:\Git\tf\linux-jump"
terraform apply -var-file="C:\Git\tf\useast1d.tfvars"

$Env:AWS_SDK_LOAD_CONFIG="1"
cd "C:\Git\tf\windows-jump"
terraform apply -var-file="C:\Git\tf\useast1d.tfvars"
