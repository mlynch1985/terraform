import boto3


def lambda_handler(event, context):
    ec2 = boto3.client("ec2")
    cloudwatch = boto3.client("cloudwatch")

    instance_id = event["instance_id"]
    detail_type = event["detail_type"]
    asg_name = event["auto_scaling_group_name"]

    instance_object = ec2.describe_instances(InstanceIds=[instance_id])

    for tag in instance_object["Reservations"][0]["Instances"][0]["Tags"]:
        if tag["Key"] == "namespace":
            namespace = tag["Value"]
        elif tag["Key"] == "component":
            component = tag["Value"]

    if "Platform" in instance_object["Reservations"][0]["Instances"][0]:
        import windows

        alarms = windows.alarms()
    else:
        import linux

        alarms = linux.alarms()

    if detail_type == "EC2 Instance Launch Successful":
        alarms.create_alarms(cloudwatch, instance_id, namespace, component, asg_name)
    elif detail_type == "EC2 Instance Terminate Successful":
        alarms.delete_alarms(cloudwatch, instance_id, namespace, component)
