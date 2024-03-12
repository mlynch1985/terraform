package aws.amazon_ec2_auto_scaling.autoscaling_launch_config_public_ip_disabled

test_autoscaling_launch_config_public_ip_disabled_valid {
	count(violations) == 0 with input as data.autoscaling_launch_config_public_ip_disabled.valid
}

test_autoscaling_launch_config_public_ip_disabled_ignore {
	count(violations) == 0 with input as data.autoscaling_launch_config_public_ip_disabled.ignore
}

test_autoscaling_launch_config_public_ip_disabled_invalid {
	r := violations with input as data.autoscaling_launch_config_public_ip_disabled.invalid
	count(r) == 1
	r[_].finding.title = "AUTOSCALING_LAUNCH_CONFIG_PUBLIC_IP_DISABLED"
	r[_].finding.uid = "AUTOSCALING-1"
}

test_autoscaling_launch_config_public_ip_disabled_no_public_key {
	r := violations with input as data.autoscaling_launch_config_public_ip_disabled.no_public_key
	count(r) == 1
	r[_].finding.title = "AUTOSCALING_LAUNCH_CONFIG_PUBLIC_IP_DISABLED"
	r[_].finding.uid = "AUTOSCALING-1"
}
