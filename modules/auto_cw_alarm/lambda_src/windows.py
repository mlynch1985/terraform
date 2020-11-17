class alarms:
    def __init__(self):
        self.data = []

    def delete_alarms(self, cloudwatch, instance_id, namespace, component):
        cloudwatch.delete_alarms(
            AlarmNames=[
                "{}_{}_{}_high_cpu".format(namespace, component, instance_id),
                "{}_{}_{}_low_disk_space".format(namespace, component, instance_id),
                "{}_{}_{}_high_disk_read".format(namespace, component, instance_id),
                "{}_{}_{}_high_disk_write".format(namespace, component, instance_id),
                "{}_{}_{}_high_memory".format(namespace, component, instance_id)
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
            Unit='Percent',
            EvaluationPeriods=5,
            Threshold=80,
            Dimensions=[
                {
                    "Name": "InstanceId",
                    "Value": instance_id
                }
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_high_cpu".format(namespace, component, instance_id)
                }
            ]
        )

        # Low_Disk_Space
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_low_disk_space".format(namespace, component, instance_id),
            AlarmDescription="This metric alarm tracks disk free space below 20% over 5 minutes",
            MetricName="LogicalDisk % Free Space",
            Namespace="{}_{}".format(namespace, component),
            Statistic="Average",
            ComparisonOperator="LessThanOrEqualToThreshold",
            Period=60,
            EvaluationPeriods=5,
            Threshold=20,
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
                    "Name": "instance",
                    "Value": "C:"
                },
                {
                    "Name": "objectname",
                    "Value": "LogicalDisk"
                }
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_low_disk_space".format(namespace, component, instance_id)
                }
            ]
        )

        # High_Disk_Read_Time
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_high_disk_read".format(namespace, component, instance_id),
            AlarmDescription="This metric alarm tracks disk read time above 80% over 5 minutes",
            MetricName="LogicalDisk % Disk Read Time",
            Namespace="{}_{}".format(namespace, component),
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
                    "Name": "instance",
                    "Value": "C:"
                },
                {
                    "Name": "objectname",
                    "Value": "LogicalDisk"
                }
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_high_disk_read".format(namespace, component, instance_id)
                }
            ]
        )

        # High_Disk_Write_Time
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_high_disk_write".format(namespace, component, instance_id),
            AlarmDescription="This metric alarm tracks disk write time above 80% over 5 minutes",
            MetricName="LogicalDisk % Disk Write Time",
            Namespace="{}_{}".format(namespace, component),
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
                    "Name": "instance",
                    "Value": "C:"
                },
                {
                    "Name": "objectname",
                    "Value": "LogicalDisk"
                }
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_high_disk_write".format(namespace, component, instance_id)
                }
            ]
        )

        # High_Memory
        cloudwatch.put_metric_alarm(
            AlarmName="{}_{}_{}_high_memory".format(namespace, component, instance_id),
            AlarmDescription="This metric alarm tracks memory availble below 500MB over 5 minutes",
            MetricName="Memory Available MBytes",
            Namespace="{}_{}".format(namespace, component),
            Statistic="Average",
            ComparisonOperator="GreaterThanOrEqualToThreshold",
            Period=60,
            EvaluationPeriods=5,
            Threshold=500,
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
                    "Name": "objectname",
                    "Value": "Memory"
                }
            ],
            Tags=[
                {
                    "Key": "Name",
                    "Value": "{}_{}_{}_high_memory".format(namespace, component, instance_id)
                }
            ]
        )
