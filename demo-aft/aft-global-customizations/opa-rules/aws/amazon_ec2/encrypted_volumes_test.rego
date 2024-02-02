package aws.amazon_ec2.encrypted_volumes


test_encrypted_volumes_valid {
    count(violations) == 0  with input as data.encrypted_volumes.valid
}

test_encrypted_volumes_ignore {
    count(violations) == 0  with input as data.encrypted_volumes.ignore
}

test_encrypted_volumes_invalid {
    r := violations with input as data.encrypted_volumes.invalid
    count(r) == 1
    r[_]["finding"]["title"] = "ENCRYPTED_VOLUMES"
    r[_]["finding"]["uid"] = "EC2-5"
}

test_encrypted_volumes_no_kms {
    r := violations with input as data.encrypted_volumes.no_kms
    count(r) == 1
    r[_]["finding"]["title"] = "ENCRYPTED_VOLUMES"
    r[_]["finding"]["uid"] = "EC2-5"
}

test_encrypted_volumes_enc_false {
    r := violations with input as data.encrypted_volumes.enc_false
    count(r) == 1
    r[_]["finding"]["title"] = "ENCRYPTED_VOLUMES"
    r[_]["finding"]["uid"] = "EC2-5"
}



