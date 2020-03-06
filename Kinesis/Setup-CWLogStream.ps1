## Create S3 Bucket
aws s3api create-bucket --bucket cwl-subscription --region us-east-1

## Create IAM Role to assume Firehose Role
aws iam create-role --role-name FirehoseToS3Role --assume-role-policy-document $('{
    "Statement": {
        "Effect": "Allow",
        "Principal": { "Service": "firehose.amazonaws.com" },
        "Action": "sts:AssumeRole",
        "Condition": { "StringEquals": { "sts:ExternalId":"662425749494" } }
    } 
}' -replace '"', '\"')

## Add S3 policy to FirehoseToS3Role
aws iam put-role-policy --role-name FirehoseToS3Role --policy-name Permissions-Policy-For-Firehose --policy-document file://C:\Temp\S3AccessPolicy.json

## Create Kinesis Delivery Stream
aws firehose create-delivery-stream --delivery-stream-name "my-delivery-stream" --s3-destination-configuration '{\"RoleARN\": \"arn:aws:iam::662425749494:role/FirehoseToS3Role\", \"BucketARN\": \"arn:aws:s3:::cwl-subscription\"}'

## #### WAIT for stream to be created #### ##
## Verify the new stream is active
aws firehose describe-delivery-stream --delivery-stream-name "my-delivery-stream"

## Create CloudWatch Role
aws iam create-role --role-name CloudWatchToFirehoseRole --assume-role-policy-document file://C:\Temp\CloudWatchToFirehoseRole.json

## Add Firehose policy to CloudWatchToFirehoseRole
aws iam put-role-policy --role-name CloudWatchToFirehoseRole --policy-name Permissions-Policy-For-CWL --policy-document file://C:\Temp\FirehoseAccessPolicy.json

## Create CloudWatch LogGroup
aws logs create-log-group --log-group-name my-logs

## Create CloudWatch Logs Subscription
aws logs put-subscription-filter `
    --log-group-name "CloudWatch" `
    --filter-name "Destination" `
    --filter-pattern "{$.eventType = *}" `
    --destination-arn "arn:aws:firehose:us-east-1:662425749494:deliverystream/my-delivery-stream" `
    --role-arn "arn:aws:iam::662425749494:role/CloudWatchToFirehoseRole"
