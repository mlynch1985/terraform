class alarms:
    def __init__(self):
        self.data = []

    def delete_alarms(self, cloudwatch, instance_id, namespace, component):
        cloudwatch.delete_alarms(
            AlarmNames=[
                "{}_{}_{}_high_cpu".format(namespace, component, instance_id),
                "{}_{}_{}_low_disk_space".format(namespace, component, instance_id),
                "{}_{}_{}_high_disk_io".format(namespace, component, instance_id),
                "{}_{}_{}_high_memory".format(namespace, component, instance_id),
            ]
        )

    def create_alarms(self, cloudwatch, instance_id, namespace, component, asg_name):
        # High_Cpu
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_high_cpu".format(namespace, component, instance_id),
            AlarmDescription="This metric alarm tracks CPU usage above 80% over 5 minutes",
            MetricName="CPUUtilization",
            Namespace="AWS/EC2",
            Statistic="Average",
            ComparisonOperator="GreaterThanOrEqualToThreshold",
            Period=60,
            Unit="Percent",
            EvaluationPeriods=5,
            Threshold=80,
            Dimensions=[{"Name": "InstanceId", "Value": instance_id}],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_high_cpu".format(
                        namespace, component, instance_id
                    ),
                }
            ],
        )

        # Low_Disk_Space
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_low_disk_space".format(
                namespace, component, instance_id
            ),
            AlarmDescription="This metric alarm tracks disk usage above 80% over 5 minutes",
            MetricName="disk_used_percent",
            Namespace="{}_{}".format(namespace, component),
            Statistic="Average",
            ComparisonOperator="GreaterThanOrEqualToThreshold",
            Period=60,
            EvaluationPeriods=5,
            Threshold=80,
            Dimensions=[
                {"Name": "InstanceId", "Value": instance_id},
                {"Name": "AutoScalingGroupName", "Value": asg_name},
                {"Name": "device", "Value": "nvme0n1p1"},
                {"Name": "fstype", "Value": "xfs"},
                {"Name": "path", "Value": "/"},
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_low_disk_space".format(
                        namespace, component, instance_id
                    ),
                }
            ],
        )

        # High_Disk_IO
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_high_disk_io".format(namespace, component, instance_id),
            AlarmDescription="This metric alarm tracks disk IO time above 1 second over 5 minutes",
            MetricName="diskio_io_time",
            Namespace="{}_{}".format(namespace, component),
            Statistic="Sum",
            ComparisonOperator="GreaterThanOrEqualToThreshold",
            Period=60,
            EvaluationPeriods=5,
            Threshold=1000,
            Dimensions=[
                {"Name": "InstanceId", "Value": instance_id},
                {"Name": "AutoScalingGroupName", "Value": asg_name},
                {"Name": "name", "Value": "nvme0n1"},
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_high_disk_io".format(
                        namespace, component, instance_id
                    ),
                }
            ],
        )

        # High_Memory
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_high_memory".format(namespace, component, instance_id),
            AlarmDescription="This metric alarm tracks memory usage above 80% over 5 minutes",
            MetricName="mem_used_percent",
            Namespace="{}_{}".format(namespace, component),
            Statistic="Average",
            ComparisonOperator="GreaterThanOrEqualToThreshold",
            Period=60,
            EvaluationPeriods=5,
            Threshold=80,
            Dimensions=[
                {"Name": "InstanceId", "Value": instance_id},
                {"Name": "AutoScalingGroupName", "Value": asg_name},
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_high_memory".format(
                        namespace, component, instance_id
                    ),
                }
            ],
        )
