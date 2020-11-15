class linux_alarms:
    def __init__(self):
        self.data = []

    def does_alarm_exist(self, cloudwatch, alarm_name):
        response = cloudwatch.describe_alarms(
            AlarmNames=[alarm_name],
            AlarmTypes=["MetricAlarm"]
        )

        if 'MetricAlarms' in response:
            return True
        else:
            return False

    def delete_alarms(self, cloudwatch, instance_id, namespace, app_role):
        cloudwatch.delete_alarms(
            AlarmNames=[
                "{}_{}_{}_high_cpu".format(namespace, app_role, instance_id),
                "{}_{}_{}_low_disk_space".format(namespace, app_role, instance_id),
                "{}_{}_{}_high_disk_io".format(namespace, app_role, instance_id),
                "{}_{}_{}_high_memory".format(namespace, app_role, instance_id)
            ]
        )

    def create_alarms(self, cloudwatch, instance_id, namespace, app_role, asg_name):
        # High_Cpu
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_high_cpu".format(namespace, app_role, instance_id),
            AlarmDescription="This metric alarm tracks CPU usage above 80% over 5 minutes",
            MetricName="cpu_usage_active",
            Namespace="{}_{}".format(namespace, app_role),
            Statistic="Average",
            ComparisonOperator="GreaterThanOrEqualToThreshold",
            Period=60,
            EvaluationPeriods=5,
            Threshold=80,
            Dimensions=[
                {
                    "Name": "InstanceId",
                    "Value": instance_id
                },
                {
                    "Name": "AutoScalingGroupName",
                    "Value": asg_name
                },
                {
                    "Name": "cpu",
                    "Value": "cpu-total"
                }
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_high_cpu".format(namespace, app_role, instance_id)
                }
            ]
        )

        # Low_Disk_Space
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_low_disk_space".format(namespace, app_role, instance_id),
            AlarmDescription="This metric alarm tracks disk usage above 80% over 5 minutes",
            MetricName="disk_used_percent",
            Namespace="{}_{}".format(namespace, app_role),
            Statistic="Average",
            ComparisonOperator="GreaterThanOrEqualToThreshold",
            Period=60,
            EvaluationPeriods=5,
            Threshold=80,
            Dimensions=[
                {
                    "Name": "InstanceId",
                    "Value": instance_id
                },
                {
                    "Name": "AutoScalingGroupName",
                    "Value": asg_name
                },
                {
                    "Name": "device",
                    "Value": "nvme0n1p1"
                },
                {
                    "Name": "fstype",
                    "Value": "xfs"
                },
                {
                    "Name": "path",
                    "Value": "/"
                }
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_low_disk_space".format(namespace, app_role, instance_id)
                }
            ]
        )

        # High_Disk_IO
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_high_disk_io".format(namespace, app_role, instance_id),
            AlarmDescription="This metric alarm tracks disk IO time above 1 second over 5 minutes",
            MetricName="diskio_io_time",
            Namespace="{}_{}".format(namespace, app_role),
            Statistic="Sum",
            ComparisonOperator="GreaterThanOrEqualToThreshold",
            Period=60,
            EvaluationPeriods=5,
            Threshold=1000,
            Dimensions=[
                {
                    "Name": "InstanceId",
                    "Value": instance_id
                },
                {
                    "Name": "AutoScalingGroupName",
                    "Value": asg_name
                },
                {
                    "Name": "name",
                    "Value": "nvme0n1"
                }
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_high_disk_io".format(namespace, app_role, instance_id)
                }
            ]
        )

        # High_Memory
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_high_memory".format(namespace, app_role, instance_id),
            AlarmDescription="This metric alarm tracks memory usage above 80% over 5 minutes",
            MetricName="mem_used_percent",
            Namespace="{}_{}".format(namespace, app_role),
            Statistic="Average",
            ComparisonOperator="GreaterThanOrEqualToThreshold",
            Period=60,
            EvaluationPeriods=5,
            Threshold=80,
            Dimensions=[
                {
                    "Name": "InstanceId",
                    "Value": instance_id
                },
                {
                    "Name": "AutoScalingGroupName",
                    "Value": asg_name
                }
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_high_memory".format(namespace, app_role, instance_id)
                }
            ]
        )
