#!/usr/bin/python

# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Reference:  https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external

import json
import os
import sys
import boto3
from boto3.session import Session

# Capture input parameters
params = {}
for line in sys.stdin:
    params = json.loads(line)

# Define our variables
aft_account_id = params["aft_account_id"]
aws_region = params["aws_region"]
logfile = "customize_codebuild_jobs.log"
output = {"stdout": "", "stderr": ""}


# Create our Logging functions
def log(msg):
    output["stdout"] += str(msg) + "\n"
    if os.path.isfile(logfile):
        f = open(logfile, "a")
    else:
        f = open(logfile, "w")

    f.write(str(msg) + "\n")
    f.close()


# Create our Logging functions
def logError(msg):
    output["stderr"] += "[ERROR] " + str(msg) + "\n"
    if os.path.isfile(logfile):
        f = open(logfile, "a")
    else:
        f = open(logfile, "w")

    f.write("[ERROR] " + str(msg) + "\n")
    f.close()


# Use Try/Catch for critical exception handling
try:
    # Remove any existing log files from prior executions
    if os.path.exists(logfile):
        os.remove(logfile)

    log("\n#### Starting Execution ####\n")

    # Load AWS STS Service library
    log("Loading STS Client")
    sts_client = boto3.client("sts")

    # Assume the AWSControlTowerExecution role within the AFT Management account
    log("Generating AssumeRole credentials for AFT Management account")
    assume_role_object = sts_client.assume_role(
        RoleArn=f"arn:aws:iam::{aft_account_id}:role/AWSControlTowerExecution",
        RoleSessionName="AWSAFT-Session",
    )

    # Setup new session credentials
    log("Creating new Boto3 Session")
    session = Session(
        aws_access_key_id=assume_role_object["Credentials"]["AccessKeyId"],
        aws_secret_access_key=assume_role_object["Credentials"]["SecretAccessKey"],
        aws_session_token=assume_role_object["Credentials"]["SessionToken"],
        region_name=aws_region,
    )

    # Validate we can assume role into target AFT Management account
    log("Validating we switched into the AFT Management Account\n")
    assume_role_client = session.client("sts")
    log(assume_role_client.get_caller_identity())

    # Load the CodeBuild Service Library using the AssumedRole session
    log("\nInitializing CodeBuild Client with AssumeRole Session")
    codebuild_client = session.client("codebuild")

    # Update our Global Customizations Project
    log("Updating Global Customizations Project\n")
    global_response = codebuild_client.update_project(
        name="aft-global-customizations-terraform",
        source={"type": "CODEPIPELINE", "buildspec": ""},
        environment={
            "type": "LINUX_CONTAINER",
            "image": "aws/codebuild/amazonlinux2-x86_64-standard:5.0",
            "computeType": "BUILD_GENERAL1_LARGE",
            "imagePullCredentialsType": "CODEBUILD",
            "environmentVariables": [
                {"name": "AWS_PARTITION", "value": "aws", "type": "PLAINTEXT"}
            ],
        },
    )

    # Log output response
    log(global_response)

    # Update our Account Customizations Project
    log("Updating Account Customizations Project\n")
    account_response = codebuild_client.update_project(
        name="aft-account-customizations-terraform",
        source={"type": "CODEPIPELINE", "buildspec": ""},
        environment={
            "type": "LINUX_CONTAINER",
            "image": "aws/codebuild/amazonlinux2-x86_64-standard:5.0",
            "computeType": "BUILD_GENERAL1_LARGE",
            "imagePullCredentialsType": "CODEBUILD",
            "environmentVariables": [
                {"name": "AWS_PARTITION", "value": "aws", "type": "PLAINTEXT"}
            ],
        },
    )

    # Log output response
    log(account_response)

    log("\n#### Execution Complete ####\n")

# Catch and log out any critical exceptions
except Exception as err:
    logError(err)

# Return a JSON object back to Terraform
print(json.dumps(output))
