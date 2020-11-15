import json
import boto3

def lambda_handler(event, context):
    # Initialize boto3 modules
    ec2 = boto3.client('ec2')
    cloudwatch = boto3.client('cloudwatch')

    # Capture Cloudwatch Event data
    instance_id = event['instance_id']
    detail_type = event['detail_type']
    asg_name = event['auto_scaling_group_name']

    # Capture details about the EC2 instance
    instance_object = ec2.describe_instances(
        InstanceIds = [instance_id]
    )

    # Loop through the EC2 instance tags and set them variables
    for tag in instance_object['Reservations'][0]['Instances'][0]['Tags']:
        if tag['Key'] == 'namespace':
            namespace = tag['Value']
        elif tag['Key'] == 'app_role':
            app_role = tag['Value']


    if 'Platform' in instance_object['Reservations'][0]['Instances'][0]: # If the Platform Key exists, we assume the EC2 instance is Windows
        import windows
        alarms = windows.windows_alarms()
    else:
        # If Platform Key does not exist, we assume the EC2 instance is Linux
        import linux
        alarms = linux.linux_alarms()

    if detail_type == "EC2 Instance Launch Successful":
        alarms.create_alarms(cloudwatch, instance_id, namespace, app_role, asg_name)
    elif detail_type == "EC2 Instance Terminate Successful":
        alarms.delete_alarms(cloudwatch, instance_id, namespace, app_role)
