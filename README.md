# Mike Lynch's Terraform Projects

[![SuperLinter](https://github.com/mlynch1985/terraform/actions/workflows/superlinter.yaml/badge.svg?branch=main)](https://github.com/mlynch1985/terraform/actions/workflows/superlinter.yaml)
[![Checkov](https://github.com/mlynch1985/terraform/actions/workflows/checkov.yaml/badge.svg?branch=main)](https://github.com/mlynch1985/terraform/actions/workflows/checkov.yaml)
[![TfSec](https://github.com/mlynch1985/terraform/actions/workflows/tfsec.yaml/badge.svg?branch=main)](https://github.com/mlynch1985/terraform/actions/workflows/tfsec.yaml)

## Description

This repository contains various Terraform based projects I am currently or have previously worked on. It is meant to be a sandbox for my development and learning as well as a portfolio to demonstrate my abilities and experience.

----

## Projects

- [Custom Modules Examples](./custom-modules-examples/README.md)
- [Custom Modules Pipeline](./custom-modules-pipeline/README.md)
- [Test Stack](./test-stack/README.md)

----

## Setup Procedures

### Install Terraform command-line interface

- Browse to the Terraform [Downloads Page](https://www.terraform.io/downloads) and follow the steps for your operating system
- Alternatively for Windows based systems, you can use Chocolatey to manage the install ([Reference](https://community.chocolatey.org/packages/terraform))

### Setup terraform command aliases on Windows

- As an admin edit this file **`C:\Program Files\Git\etc\profile.d\aliases.sh`**
- Starting on line 7 create as many aliases as you would like
- Example: **`alias tf='terraform'`**

### Use Terraform Cloud to track state and allow for collaboration

- Create/Sign-in to a Terraform Cloud Account ([Click Here](https://app.terraform.io/session))
- Create/Join an Organization ([Click Here](https://app.terraform.io/app/settings/organizations))
- Create a workspace for your project
- In the terraform code block add the below configuration

```terraform
terraform {
  cloud {
    organization = "{{ORG_NAME}}"

    workspaces {
      name = "{{WORKSPACE_NAME}}"
    }
  }
}
```

----

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
