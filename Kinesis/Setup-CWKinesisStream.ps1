## Create Kinesis Data Stream
aws kinesis create-stream --stream-name "CWLDataStream" --shard-count 1

## Verify Stream is Active before continuing
aws kinesis describe-stream --stream-name "CWLDataStream"

## Create CWL to Kinesis Role
aws iam create-role --role-name CWLtoKinesisRole --assume-role-policy-document $('{
    "Statement": {
        "Effect": "Allow",
        "Principal": { "Service": "logs.us-east-1.amazonaws.com" },
        "Action": "sts:AssumeRole"
    }
}
' -replace '"', '\"')

## Add Policy to the Kinesis Role
aws iam put-role-policy --role-name CWLtoKinesisRole --policy-name Permissions-Policy-For-CWL --policy-document $('{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "kinesis:PutRecord",
            "Resource": "arn:aws:kinesis:us-east-1:662425749494:stream/CWLDataStream"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::662425749494:role/CWLtoKinesisRole"
        }
    ]
}
' -replace '"', '\"')

## Create CloudWatch Log Subscription
aws logs put-subscription-filter `
    --log-group-name "CloudWatch" `
    --filter-name "CWLDataStream" `
    --filter-pattern "{$.userIdentity.type = Root}" `
    --destination-arn "arn:aws:kinesis:us-east-1:662425749494:stream/CWLDataStream" `
    --role-arn "arn:aws:iam::662425749494:role/CWLtoKinesisRole"

## Get Shard Iterator
$ShardIterator = (aws kinesis get-shard-iterator --stream-name CWLDataStream --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON | ConvertFrom-Json)[0].ShardIterator

## Get Records
$Records = (aws kinesis get-records --limit 10 --shard-iterator $ShardIterator | ConvertFrom-Json)[0].Records

