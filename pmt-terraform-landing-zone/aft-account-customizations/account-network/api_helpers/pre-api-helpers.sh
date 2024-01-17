#!/bin/bash
# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

echo "Executing Pre-API Helpers"

REGION1="us-east-1"
REGION2="us-west-2"

DISCOVERY_ID=$(aws ec2 describe-ipam-resource-discoveries \
  --region $REGION1 \
  --query 'IpamResourceDiscoveries[0].IpamResourceDiscoveryId' \
  --output text
)

aws ec2 get-ipam-discovered-resource-cidrs \
  --ipam-resource-discovery-id $DISCOVERY_ID \
  --resource-region $REGION1 \
  --filters Name="resource-type",Values="vpc" \
  --query "IpamDiscoveredResourceCidrs[?ResourceTags[?Key=='TGW_Route_Auto_Enable' && Value=='true']].{AccountId: ResourceOwnerId, VpcId: VpcId, VpcCidr: ResourceCidr}" \
  > $DEFAULT_PATH/$CUSTOMIZATION/terraform/ipam_cidrs_region1.json

aws ec2 get-ipam-discovered-resource-cidrs \
  --ipam-resource-discovery-id $DISCOVERY_ID \
  --resource-region $REGION2 \
  --filters Name="resource-type",Values="vpc" \
  --query "IpamDiscoveredResourceCidrs[?ResourceTags[?Key=='TGW_Route_Auto_Enable' && Value=='true']].{AccountId: ResourceOwnerId, VpcId: VpcId, VpcCidr: ResourceCidr}" \
  > $DEFAULT_PATH/$CUSTOMIZATION/terraform/ipam_cidrs_region2.json
