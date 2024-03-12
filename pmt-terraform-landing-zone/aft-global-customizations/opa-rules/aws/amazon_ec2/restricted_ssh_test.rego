package aws.amazon_ec2.restricted_ssh


test_restricted_ssh_sg_valid {
    count(violations) == 0  with input as data.restricted_ssh.sg_valid
}


test_restricted_ssh_ignore {
    count(violations) == 0  with input as data.restricted_ssh.ignore
}

test_restricted_ssh_sg_invalid {
    r := violations with input as data.restricted_ssh.sg_invalid
    count(r) == 1
    r[_]["finding"]["title"] = "INCOMING_SSH_DISABLED"
    r[_]["finding"]["uid"] = "EC2-8"
}

test_restricted_ssh_sgr_valid {
    count(violations) == 0  with input as data.restricted_ssh.sgr_valid
}


test_restricted_ssh_sgr_invalid {
    r := violations with input as data.restricted_ssh.sgr_invalid
    count(r) == 1
    r[_]["finding"]["title"] = "INCOMING_SSH_DISABLED"
    r[_]["finding"]["uid"] = "EC2-8"
}



