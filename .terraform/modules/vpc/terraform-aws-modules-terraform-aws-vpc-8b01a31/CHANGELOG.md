<a name="unreleased"></a>
## [Unreleased]



<a name="v2.24.0"></a>
## [v2.24.0] - 2020-01-23

- Set minimum terraform version to 0.12.6 (fixes circleci) ([#390](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/390))


<a name="v2.23.0"></a>
## [v2.23.0] - 2020-01-21

- Updated CHANGELOG
- Updated pre-commit-terraform with terraform-docs 0.8.0 support ([#388](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/388))


<a name="v2.22.0"></a>
## [v2.22.0] - 2020-01-16

- Updated CHANGELOG
- Added note about Transit Gateway integration ([#386](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/386))


<a name="v2.21.0"></a>
## [v2.21.0] - 2019-11-27

- Updated CHANGELOG
- fix ipv6 enable ([#340](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/340))


<a name="v2.20.0"></a>
## [v2.20.0] - 2019-11-27

- Updated CHANGELOG
- Added Customer Gateway resource ([#360](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/360))
- Update TFLint to v0.12.1 for circleci ([#351](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/351))


<a name="v2.19.0"></a>
## [v2.19.0] - 2019-11-27

- Updated CHANGELOG
- Add Elastic File System & Cloud Directory VPC Endpoints ([#355](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/355))


<a name="v2.18.0"></a>
## [v2.18.0] - 2019-11-04

- Updated CHANGELOG
- Fixed spelling mistakes
- Updated CHANGELOG
- Updated network-acls example with IPv6 rules
- Added support for `ipv6_cidr_block` in network acls ([#329](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/329))
- Updated CHANGELOG
- Added VPC Endpoints for AppStream, Athena & Rekognition ([#335](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/335))
- Updated CHANGELOG
- Add VPC endpoints for CloudFormation, CodePipeline, Storage Gateway, AppMesh, Transfer, Service Catalog & SageMaker(Runtime & API) ([#324](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/324))
- Updated CHANGELOG
- Added support for EC2 ClassicLink ([#322](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/322))
- Updated CHANGELOG
- Added support for ICMP rules in Network ACL ([#286](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/286))
- Updated CHANGELOG
- Added tags to VPC Endpoints ([#292](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/292))
- Updated CHANGELOG
- Added more VPC endpoints (Glue, STS, Sagemaker Notebook), and all missing outputs ([#311](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/311))
- Updated CHANGELOG
- Add IPv6 support ([#317](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/317))
- Updated CHANGELOG
- Fixed README after merge
- Output var.name ([#303](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/303))
- Updated CHANGELOG
- Fixed README after merge
- Additional VPC Endpoints ([#302](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/302))
- Added Kinesis streams and firehose VPC endpoints ([#301](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/301))
- adding transfer server vpc end point support
- adding codebuild, codecommit and git-codecommit vpc end point support
- adding config vpc end point support
- adding secrets manager vpc end point support
- Updated version of pre-commit-terraform
- Updated CHANGELOG
- Updated pre-commit-terraform to support terraform-docs and Terraform 0.12 ([#288](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/288))
- Updated CHANGELOG
- Updated VPC endpoint example (fixed [#249](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/249))
- Update tflint to 0.8.2 for circleci task ([#280](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/280))
- Updated CHANGELOG
- Updated CHANGELOG
- Fixed broken 2.3.0
- Updated CHANGELOG
- Fixed opportunity to create the vpc, vpn gateway routes (bug during upgrade to 0.12)
- Updated CHANGELOG
- Updated Terraform versions in README
- Updated CHANGELOG
- Added VPC Endpoints for SNS, Cloudtrail, ELB, Cloudwatch ([#269](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/269))
- Upgrade Docker Image to fix CI ([#270](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/270))
- Updated CHANGELOG
- Fixed merge conflicts
- Finally, Terraform 0.12 support ([#266](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/266))


<a name="v1.72.0"></a>
## [v1.72.0] - 2019-09-30

- Updated CHANGELOG
- Add VPC endpoints for AppStream, Athena & Rekognition ([#336](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/336))
- Updated CHANGELOG
- Fixed Sagemaker resource name in VPC endpoint ([#323](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/323))
- Fixed name of appmesh VPC endpoint ([#320](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/320))
- Updated CHANGELOG
- Allow ICMP Network ACL rules ([#252](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/252))
- Updated CHANGELOG
- Added VPC endpoints from [#311](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/311) to Terraform 0.11 branch ([#319](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/319))
- Updated CHANGELOG
- Add tags to VPC Endpoints ([#293](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/293))
- Updated CHANGELOG
- Add VPC endpoints for ELB, CloudTrail, CloudWatch and SNS ([#274](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/274))


<a name="v2.17.0"></a>
## [v2.17.0] - 2019-09-30

- Updated CHANGELOG
- Updated network-acls example with IPv6 rules
- Added support for `ipv6_cidr_block` in network acls ([#329](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/329))


<a name="v2.16.0"></a>
## [v2.16.0] - 2019-09-30

- Updated CHANGELOG
- Added VPC Endpoints for AppStream, Athena & Rekognition ([#335](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/335))


<a name="v2.15.0"></a>
## [v2.15.0] - 2019-09-03

- Updated CHANGELOG
- Add VPC endpoints for CloudFormation, CodePipeline, Storage Gateway, AppMesh, Transfer, Service Catalog & SageMaker(Runtime & API) ([#324](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/324))
- Updated CHANGELOG
- Added support for EC2 ClassicLink ([#322](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/322))
- Updated CHANGELOG
- Added support for ICMP rules in Network ACL ([#286](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/286))
- Updated CHANGELOG
- Added tags to VPC Endpoints ([#292](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/292))
- Updated CHANGELOG
- Added more VPC endpoints (Glue, STS, Sagemaker Notebook), and all missing outputs ([#311](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/311))
- Updated CHANGELOG
- Add IPv6 support ([#317](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/317))
- Updated CHANGELOG
- Fixed README after merge
- Output var.name ([#303](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/303))
- Updated CHANGELOG
- Fixed README after merge
- Additional VPC Endpoints ([#302](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/302))
- Added Kinesis streams and firehose VPC endpoints ([#301](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/301))
- adding transfer server vpc end point support
- adding codebuild, codecommit and git-codecommit vpc end point support
- adding config vpc end point support
- adding secrets manager vpc end point support
- Updated version of pre-commit-terraform
- Updated CHANGELOG
- Updated pre-commit-terraform to support terraform-docs and Terraform 0.12 ([#288](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/288))
- Updated CHANGELOG
- Updated VPC endpoint example (fixed [#249](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/249))
- Update tflint to 0.8.2 for circleci task ([#280](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/280))
- Updated CHANGELOG
- Updated CHANGELOG
- Fixed broken 2.3.0
- Updated CHANGELOG
- Fixed opportunity to create the vpc, vpn gateway routes (bug during upgrade to 0.12)
- Updated CHANGELOG
- Updated Terraform versions in README
- Updated CHANGELOG
- Added VPC Endpoints for SNS, Cloudtrail, ELB, Cloudwatch ([#269](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/269))
- Upgrade Docker Image to fix CI ([#270](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/270))
- Updated CHANGELOG
- Fixed merge conflicts
- Finally, Terraform 0.12 support ([#266](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/266))


<a name="v1.71.0"></a>
## [v1.71.0] - 2019-09-03

- Updated CHANGELOG
- Fixed Sagemaker resource name in VPC endpoint ([#323](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/323))
- Fixed name of appmesh VPC endpoint ([#320](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/320))
- Updated CHANGELOG
- Allow ICMP Network ACL rules ([#252](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/252))
- Updated CHANGELOG
- Added VPC endpoints from [#311](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/311) to Terraform 0.11 branch ([#319](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/319))
- Updated CHANGELOG
- Add tags to VPC Endpoints ([#293](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/293))
- Updated CHANGELOG
- Add VPC endpoints for ELB, CloudTrail, CloudWatch and SNS ([#274](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/274))


<a name="v2.14.0"></a>
## [v2.14.0] - 2019-09-03

- Updated CHANGELOG
- Added support for EC2 ClassicLink ([#322](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/322))


<a name="v2.13.0"></a>
## [v2.13.0] - 2019-09-03

- Updated CHANGELOG
- Added support for ICMP rules in Network ACL ([#286](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/286))
- Updated CHANGELOG
- Added tags to VPC Endpoints ([#292](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/292))
- Updated CHANGELOG
- Added more VPC endpoints (Glue, STS, Sagemaker Notebook), and all missing outputs ([#311](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/311))
- Updated CHANGELOG
- Add IPv6 support ([#317](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/317))
- Updated CHANGELOG
- Fixed README after merge
- Output var.name ([#303](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/303))
- Updated CHANGELOG
- Fixed README after merge
- Additional VPC Endpoints ([#302](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/302))
- Added Kinesis streams and firehose VPC endpoints ([#301](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/301))
- adding transfer server vpc end point support
- adding codebuild, codecommit and git-codecommit vpc end point support
- adding config vpc end point support
- adding secrets manager vpc end point support
- Updated version of pre-commit-terraform
- Updated CHANGELOG
- Updated pre-commit-terraform to support terraform-docs and Terraform 0.12 ([#288](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/288))
- Updated CHANGELOG
- Updated VPC endpoint example (fixed [#249](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/249))
- Update tflint to 0.8.2 for circleci task ([#280](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/280))
- Updated CHANGELOG
- Updated CHANGELOG
- Fixed broken 2.3.0
- Updated CHANGELOG
- Fixed opportunity to create the vpc, vpn gateway routes (bug during upgrade to 0.12)
- Updated CHANGELOG
- Updated Terraform versions in README
- Updated CHANGELOG
- Added VPC Endpoints for SNS, Cloudtrail, ELB, Cloudwatch ([#269](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/269))
- Upgrade Docker Image to fix CI ([#270](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/270))
- Updated CHANGELOG
- Fixed merge conflicts
- Finally, Terraform 0.12 support ([#266](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/266))


<a name="v1.70.0"></a>
## [v1.70.0] - 2019-09-03

- Updated CHANGELOG
- Allow ICMP Network ACL rules ([#252](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/252))


<a name="v1.69.0"></a>
## [v1.69.0] - 2019-09-03

- Updated CHANGELOG
- Added VPC endpoints from [#311](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/311) to Terraform 0.11 branch ([#319](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/319))


<a name="v1.68.0"></a>
## [v1.68.0] - 2019-09-02

- Updated CHANGELOG
- Add tags to VPC Endpoints ([#293](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/293))
- Updated CHANGELOG
- Add VPC endpoints for ELB, CloudTrail, CloudWatch and SNS ([#274](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/274))


<a name="v2.12.0"></a>
## [v2.12.0] - 2019-09-02

- Updated CHANGELOG
- Added tags to VPC Endpoints ([#292](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/292))


<a name="v2.11.0"></a>
## [v2.11.0] - 2019-09-02

- Updated CHANGELOG
- Added more VPC endpoints (Glue, STS, Sagemaker Notebook), and all missing outputs ([#311](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/311))


<a name="v2.10.0"></a>
## [v2.10.0] - 2019-09-02

- Updated CHANGELOG
- Add IPv6 support ([#317](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/317))


<a name="v2.9.0"></a>
## [v2.9.0] - 2019-07-21

- Updated CHANGELOG
- Fixed README after merge
- Output var.name ([#303](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/303))


<a name="v2.8.0"></a>
## [v2.8.0] - 2019-07-21

- Updated CHANGELOG
- Fixed README after merge
- Additional VPC Endpoints ([#302](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/302))
- Added Kinesis streams and firehose VPC endpoints ([#301](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/301))
- adding transfer server vpc end point support
- adding codebuild, codecommit and git-codecommit vpc end point support
- adding config vpc end point support
- adding secrets manager vpc end point support
- Updated version of pre-commit-terraform


<a name="v2.7.0"></a>
## [v2.7.0] - 2019-06-17

- Updated CHANGELOG
- Updated pre-commit-terraform to support terraform-docs and Terraform 0.12 ([#288](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/288))


<a name="v2.6.0"></a>
## [v2.6.0] - 2019-06-13

- Updated CHANGELOG
- Updated VPC endpoint example (fixed [#249](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/249))
- Update tflint to 0.8.2 for circleci task ([#280](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/280))
- Updated CHANGELOG
- Updated CHANGELOG
- Fixed broken 2.3.0
- Updated CHANGELOG
- Fixed opportunity to create the vpc, vpn gateway routes (bug during upgrade to 0.12)
- Updated CHANGELOG
- Updated Terraform versions in README
- Updated CHANGELOG
- Added VPC Endpoints for SNS, Cloudtrail, ELB, Cloudwatch ([#269](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/269))
- Upgrade Docker Image to fix CI ([#270](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/270))
- Updated CHANGELOG
- Fixed merge conflicts
- Finally, Terraform 0.12 support ([#266](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/266))


<a name="v1.67.0"></a>
## [v1.67.0] - 2019-06-13

- Updated CHANGELOG
- Add VPC endpoints for ELB, CloudTrail, CloudWatch and SNS ([#274](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/274))


<a name="v2.5.0"></a>
## [v2.5.0] - 2019-06-05

- Updated CHANGELOG


<a name="v2.4.0"></a>
## [v2.4.0] - 2019-06-05

- Updated CHANGELOG
- Fixed broken 2.3.0


<a name="v2.3.0"></a>
## [v2.3.0] - 2019-06-04

- Updated CHANGELOG
- Fixed opportunity to create the vpc, vpn gateway routes (bug during upgrade to 0.12)


<a name="v2.2.0"></a>
## [v2.2.0] - 2019-05-28

- Updated CHANGELOG
- Updated Terraform versions in README


<a name="v2.1.0"></a>
## [v2.1.0] - 2019-05-27

- Updated CHANGELOG
- Added VPC Endpoints for SNS, Cloudtrail, ELB, Cloudwatch ([#269](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/269))
- Upgrade Docker Image to fix CI ([#270](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/270))


<a name="v2.0.0"></a>
## [v2.0.0] - 2019-05-24

- Updated CHANGELOG
- Fixed merge conflicts
- Finally, Terraform 0.12 support ([#266](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/266))


<a name="v1.66.0"></a>
## [v1.66.0] - 2019-05-24

- Updated CHANGELOG
- Added VPC endpoints for SQS (closes [#248](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/248))
- ECS endpoint ([#261](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/261))


<a name="v1.65.0"></a>
## [v1.65.0] - 2019-05-21

- Updated CHANGELOG
- Improving DHCP options docs ([#260](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/260))


<a name="v1.64.0"></a>
## [v1.64.0] - 2019-04-25

- Updated CHANGELOG
- Fixed formatting
- Add Output Of Subnet ARNs ([#242](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/242))


<a name="v1.63.0"></a>
## [v1.63.0] - 2019-04-25

- Updated CHANGELOG
- Fixed formatting
- Added ARN of VPC in module output ([#245](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/245))


<a name="v1.62.0"></a>
## [v1.62.0] - 2019-04-25

- Updated CHANGELOG
- Add support for KMS VPC endpoint creation ([#243](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/243))


<a name="v1.61.0"></a>
## [v1.61.0] - 2019-04-25

- Updated CHANGELOG
- Added missing VPC endpoints outputs (resolves [#246](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/246)) ([#247](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/247))


<a name="v1.60.0"></a>
## [v1.60.0] - 2019-03-22

- Updated CHANGELOG
- Network ACLs ([#238](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/238))


<a name="v1.59.0"></a>
## [v1.59.0] - 2019-03-05

- Updated changelog
- Resolved conflicts after merge
- Redshift public subnets ([#222](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/222))
- Redshift public subnets ([#222](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/222))
- docs: Update comment in docs ([#226](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/226))


<a name="v1.58.0"></a>
## [v1.58.0] - 2019-03-01

- Updated changelog
- API gateway Endpoint ([#225](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/225))


<a name="v1.57.0"></a>
## [v1.57.0] - 2019-02-21

- Bump version
- Added CHANGELOG.md ([#221](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/221))


<a name="v1.56.0"></a>
## [v1.56.0] - 2019-02-21

- Added intra subnet suffix. ([#220](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/220))


<a name="v1.55.0"></a>
## [v1.55.0] - 2019-02-14

- Fixed formatting after [#213](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/213)
- Merge pull request [#213](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/213) from michieldhadamus/ecr-endpoints
- Added subnet ids to ecr endpoints
- Added option to create ECR api and dkr endpoints


<a name="v1.54.0"></a>
## [v1.54.0] - 2019-02-14

- Fixed formatting after [#205](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/205)
- Merge pull request [#205](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/205) from tbugfinder/extend_endpoints
- switch to terraform-docs v0.6.0
- add files updated by pre-commit
- add additional endpoints to examples
- fix typo
- add endpoints ec2messages, ssmmessages as those are required by Systems Manager in addition to ec2 and ssm.
- Merge pull request [#1](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/1) from terraform-aws-modules/master


<a name="v1.53.0"></a>
## [v1.53.0] - 2019-01-18

- Reordered vars in count for database_nat_gateway route
- Merge pull request [#201](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/201) from ebarault/feat/database-route-to-natgw
- adding option to create a route to nat gateway in database subnets


<a name="v1.52.0"></a>
## [v1.52.0] - 2019-01-17

- Merge pull request [#202](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/202) from terraform-aws-modules/ssm_and_ec2_vpc_endpoints
- Added SSM and EC2 VPC endpoints (fixes [#195](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/195), [#194](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/194))


<a name="v1.51.0"></a>
## [v1.51.0] - 2019-01-10

- Merge pull request [#199](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/199) from terraform-aws-modules/elasticache_subnet_group
- Added possibility to control creation of elasticache and redshift subnet groups


<a name="v1.50.0"></a>
## [v1.50.0] - 2018-12-27

- Added azs to outputs which is an argument


<a name="v1.49.0"></a>
## [v1.49.0] - 2018-12-12

- Merge pull request [#191](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/191) from terraform-aws-modules/feature-db-igw-public-access
- Reverted complete-example
- Added IGW route for DB subnets (based on [#179](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/179))


<a name="v1.48.0"></a>
## [v1.48.0] - 2018-12-11

- Updated pre-commit version with new terraform-docs script


<a name="v1.47.0"></a>
## [v1.47.0] - 2018-12-11

- Merge pull request [#181](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/181) from Miyurz/fix/redshift-name-issue
- Fix for the error: module.vpc.aws_redshift_subnet_group.redshift: only lowercase alphanumeric characters and hyphens allowed in name


<a name="v1.46.0"></a>
## [v1.46.0] - 2018-10-06

- Fixed [#177](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/177) - public_subnets should not always be validated


<a name="v1.45.0"></a>
## [v1.45.0] - 2018-10-01

- Updated README.md after merge
- Added amazon_side_asn to vpn_gateway ([#159](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/159))


<a name="v1.44.0"></a>
## [v1.44.0] - 2018-09-18

- Reordering tag merging ([#148](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/148))


<a name="v1.43.2"></a>
## [v1.43.2] - 2018-09-17

- Updated link to cloudcraft


<a name="v1.43.1"></a>
## [v1.43.1] - 2018-09-17

- Updated link to cloudcraft


<a name="v1.43.0"></a>
## [v1.43.0] - 2018-09-16

- Removed comments starting from # to fix README
- Added cloudcraft.co as a sponsor for this module
- Added cloudcraft.co as a sponsor for this module


<a name="v1.42.0"></a>
## [v1.42.0] - 2018-09-14

- add vars for custom subnet and route table names ([#168](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/168))


<a name="v1.41.0"></a>
## [v1.41.0] - 2018-09-04

- Add secondary CIDR block support ([#163](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/163))


<a name="v1.40.0"></a>
## [v1.40.0] - 2018-08-19

- Removed IPv6 from outputs (fixed [#157](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/157)) ([#158](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/158))


<a name="v1.39.0"></a>
## [v1.39.0] - 2018-08-19

- Add minimum support for IPv6 to VPC ([#156](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/156))


<a name="v1.38.0"></a>
## [v1.38.0] - 2018-08-18

- Provide separate route tables for db/elasticache/redshift ([#155](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/155))
- Fixing typo overriden -> overridden ([#150](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/150))


<a name="v1.37.0"></a>
## [v1.37.0] - 2018-06-22

- Removed obsolete default_route_table_tags (fixed [#146](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/146))


<a name="v1.36.0"></a>
## [v1.36.0] - 2018-06-20

- Allow tags override for all resources (fix for [#138](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/138)) ([#145](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/145))


<a name="v1.35.0"></a>
## [v1.35.0] - 2018-06-20

- Updated README after [#141](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/141)
- Add `nat_gateway_tags` input ([#141](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/141))


<a name="v1.34.0"></a>
## [v1.34.0] - 2018-06-05

- Fixed creation of aws_vpc_endpoint_route_table_association when intra_subnets are not set (fixes 137)


<a name="v1.33.0"></a>
## [v1.33.0] - 2018-06-04

- Added missing route_table for intra_subnets, and prepare the release
- Adding "intra subnets" as a class ([#135](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/135))


<a name="v1.32.0"></a>
## [v1.32.0] - 2018-05-24

- Prepared release, updated README a bit
- Fix [#117](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/117) - Add `one_nat_gateway_per_az` functionality ([#129](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/129))


<a name="v1.31.0"></a>
## [v1.31.0] - 2018-05-16

- Added pre-commit hook to autogenerate terraform-docs ([#127](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/127))


<a name="v1.30.0"></a>
## [v1.30.0] - 2018-04-09

- Fixed formatting
- Added longer timeouts for aws_route create ([#113](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/113))


<a name="v1.29.0"></a>
## [v1.29.0] - 2018-04-05

- Creates a single private route table when single_nat_gateway is true ([#83](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/83))


<a name="v1.28.0"></a>
## [v1.28.0] - 2018-04-05

- Ensures the correct number of S3 and DDB VPC Endpoint associations ([#90](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/90))


<a name="v1.27.0"></a>
## [v1.27.0] - 2018-04-05

- Removed aws_default_route_table and aws_main_route_table_association, added potentially failed example ([#111](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/111))


<a name="v1.26.0"></a>
## [v1.26.0] - 2018-03-06

- Added default CIDR block as 0.0.0.0/0 ([#93](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/93))


<a name="v1.25.0"></a>
## [v1.25.0] - 2018-03-02

- Fixed complete example
- Make terraform recognize lists when uring variables ([#92](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/92))


<a name="v1.24.0-pre"></a>
## [v1.24.0-pre] - 2018-03-01

- Fixed description
- Fixed aws_vpn_gateway_route_propagation for default route table


<a name="v1.23.0"></a>
## [v1.23.0] - 2018-02-10

- Extended aws_vpn_gateway use case. ([#67](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/67))


<a name="v1.22.1"></a>
## [v1.22.1] - 2018-02-10

- Removed classiclink from outputs because it is not present in recent regions ([#78](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/78))


<a name="v1.22.0"></a>
## [v1.22.0] - 2018-02-09

- Added support for default VPC resource ([#75](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/75))


<a name="v1.21.0"></a>
## [v1.21.0] - 2018-02-09

- Added possibility to create VPC conditionally ([#74](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/74))


<a name="v1.20.0"></a>
## [v1.20.0] - 2018-02-09

- Manage Default Route Table under Terraform ([#69](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/69))


<a name="v1.19.0"></a>
## [v1.19.0] - 2018-02-09

- Only create one public route association for s3 endpoint ([#73](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/73))


<a name="v1.18.0"></a>
## [v1.18.0] - 2018-02-05

- Adding tests for vpc, subnets, and route tables ([#31](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/31))
- Improve documentation about the usage of external NAT gateway IPs ([#66](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/66))


<a name="v1.17.0"></a>
## [v1.17.0] - 2018-01-21

- Issue [#58](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/58): Add ElastiCache subnet group name output. ([#60](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/60))


<a name="v1.16.0"></a>
## [v1.16.0] - 2018-01-21

- Terraform fmt
- Issue [#56](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/56): Added tags for elastic ips ([#61](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/61))


<a name="v1.15.0"></a>
## [v1.15.0] - 2018-01-19

- Lowercase database subnet group name ([#57](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/57))


<a name="v1.14.0"></a>
## [v1.14.0] - 2018-01-11

- Add Redshift subnets ([#54](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/54))
- [ci skip] Get more Open Source Helpers ([#51](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/51))


<a name="v1.13.0"></a>
## [v1.13.0] - 2018-01-03

- Ignore changes to propagating_vgws of private routing table ([#50](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/50))


<a name="v1.12.0"></a>
## [v1.12.0] - 2017-12-12

- Downgraded require_version from 0.10.13 to 0.10.3 ([#48](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/48))


<a name="v1.11.0"></a>
## [v1.11.0] - 2017-12-11

- Added fix for issue when no private subnets are defined ([#47](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/47))


<a name="v1.10.0"></a>
## [v1.10.0] - 2017-12-11

- Fixing edge case when VPC is not symmetrical with few private subnets ([#45](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/45))


<a name="v1.9.1"></a>
## [v1.9.1] - 2017-12-07

- Minor fix in README


<a name="v1.9.0"></a>
## [v1.9.0] - 2017-12-07

- Allow passing in EIPs for the NAT Gateways ([#38](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/38))


<a name="v1.8.0"></a>
## [v1.8.0] - 2017-12-06

- change conditional private routes ([#36](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/36))


<a name="v1.7.0"></a>
## [v1.7.0] - 2017-12-06

- Add extra tags for DHCP option set ([#42](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/42))
- Add "default_route_table_id" to outputs ([#41](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/41))


<a name="v1.6.0"></a>
## [v1.6.0] - 2017-12-06

- Add support for additional tags on VPC ([#43](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/43))
- Reverted bad merge, fixed [#33](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/33)
- Set enable_dns_support=true by default


<a name="v1.4.1"></a>
## [v1.4.1] - 2017-11-23

- Reverted bad merge, fixed [#33](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/33)


<a name="v1.5.0"></a>
## [v1.5.0] - 2017-11-23



<a name="v1.5.1"></a>
## [v1.5.1] - 2017-11-23

- Reverted bad merge, fixed [#33](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/33)
- Set enable_dns_support=true by default
- Updated descriptions for DNS variables (closes [#14](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/14))


<a name="v1.4.0"></a>
## [v1.4.0] - 2017-11-22

- Add version requirements in README.md (fixes [#32](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/32))
- Add version requirements in README.md


<a name="v1.3.0"></a>
## [v1.3.0] - 2017-11-16

- make sure outputs are always valid ([#29](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/29))
- Add tags to the aws_vpc_dhcp_options resource ([#30](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/30))


<a name="v1.2.0"></a>
## [v1.2.0] - 2017-11-11

- Add support for DHCP options set ([#20](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/20))


<a name="v1.1.0"></a>
## [v1.1.0] - 2017-11-11

- [#22](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/22) add vpn gateway feature ([#24](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/24))
- Add cidr_block outputs to public and private subnets ([#19](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/19))
- Merge pull request [#13](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/13) from felixb/nat-gateway-tags
- Add AZ to natgateway name


<a name="v1.0.4"></a>
## [v1.0.4] - 2017-10-20

- Merge pull request [#12](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/12) from michalschott/master
- NAT gateway should be tagged too.


<a name="v1.0.3"></a>
## [v1.0.3] - 2017-10-12

- Make aws_vpc_endpoint_service conditional
- Merge pull request [#7](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/7) from eheydrick/variable-descriptions
- Improve variable descriptions


<a name="v1.0.2"></a>
## [v1.0.2] - 2017-09-27

- Merge pull request [#6](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/6) from mgresko/fix_govcloud
- disable dynamodb data source when not needed


<a name="v1.0.1"></a>
## [v1.0.1] - 2017-09-26

- Updated link in README
- Merge pull request [#3](https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/3) from gas-buddy/gasbuddy/eherot/custom_route_tags
- Allow the user to define custom tags for route tables


<a name="v1.0.0"></a>
## v1.0.0 - 2017-09-12

- Updated README
- Updated README
- Aded examples and updated names
- Added descriptions, applied fmt
- Removed parts of readme
- Initial commit
- Initial commit


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.24.0...HEAD
[v2.24.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.23.0...v2.24.0
[v2.23.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.22.0...v2.23.0
[v2.22.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.21.0...v2.22.0
[v2.21.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.20.0...v2.21.0
[v2.20.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.19.0...v2.20.0
[v2.19.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.18.0...v2.19.0
[v2.18.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.72.0...v2.18.0
[v1.72.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.17.0...v1.72.0
[v2.17.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.16.0...v2.17.0
[v2.16.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.15.0...v2.16.0
[v2.15.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.71.0...v2.15.0
[v1.71.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.14.0...v1.71.0
[v2.14.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.13.0...v2.14.0
[v2.13.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.70.0...v2.13.0
[v1.70.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.69.0...v1.70.0
[v1.69.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.68.0...v1.69.0
[v1.68.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.12.0...v1.68.0
[v2.12.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.11.0...v2.12.0
[v2.11.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.10.0...v2.11.0
[v2.10.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.9.0...v2.10.0
[v2.9.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.8.0...v2.9.0
[v2.8.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.7.0...v2.8.0
[v2.7.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.6.0...v2.7.0
[v2.6.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.67.0...v2.6.0
[v1.67.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.5.0...v1.67.0
[v2.5.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.4.0...v2.5.0
[v2.4.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.3.0...v2.4.0
[v2.3.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.2.0...v2.3.0
[v2.2.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.1.0...v2.2.0
[v2.1.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v2.0.0...v2.1.0
[v2.0.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.66.0...v2.0.0
[v1.66.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.65.0...v1.66.0
[v1.65.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.64.0...v1.65.0
[v1.64.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.63.0...v1.64.0
[v1.63.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.62.0...v1.63.0
[v1.62.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.61.0...v1.62.0
[v1.61.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.60.0...v1.61.0
[v1.60.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.59.0...v1.60.0
[v1.59.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.58.0...v1.59.0
[v1.58.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.57.0...v1.58.0
[v1.57.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.56.0...v1.57.0
[v1.56.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.55.0...v1.56.0
[v1.55.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.54.0...v1.55.0
[v1.54.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.53.0...v1.54.0
[v1.53.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.52.0...v1.53.0
[v1.52.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.51.0...v1.52.0
[v1.51.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.50.0...v1.51.0
[v1.50.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.49.0...v1.50.0
[v1.49.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.48.0...v1.49.0
[v1.48.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.47.0...v1.48.0
[v1.47.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.46.0...v1.47.0
[v1.46.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.45.0...v1.46.0
[v1.45.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.44.0...v1.45.0
[v1.44.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.43.2...v1.44.0
[v1.43.2]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.43.1...v1.43.2
[v1.43.1]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.43.0...v1.43.1
[v1.43.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.42.0...v1.43.0
[v1.42.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.41.0...v1.42.0
[v1.41.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.40.0...v1.41.0
[v1.40.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.39.0...v1.40.0
[v1.39.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.38.0...v1.39.0
[v1.38.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.37.0...v1.38.0
[v1.37.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.36.0...v1.37.0
[v1.36.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.35.0...v1.36.0
[v1.35.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.34.0...v1.35.0
[v1.34.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.33.0...v1.34.0
[v1.33.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.32.0...v1.33.0
[v1.32.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.31.0...v1.32.0
[v1.31.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.30.0...v1.31.0
[v1.30.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.29.0...v1.30.0
[v1.29.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.28.0...v1.29.0
[v1.28.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.27.0...v1.28.0
[v1.27.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.26.0...v1.27.0
[v1.26.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.25.0...v1.26.0
[v1.25.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.24.0-pre...v1.25.0
[v1.24.0-pre]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.23.0...v1.24.0-pre
[v1.23.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.22.1...v1.23.0
[v1.22.1]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.22.0...v1.22.1
[v1.22.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.21.0...v1.22.0
[v1.21.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.20.0...v1.21.0
[v1.20.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.19.0...v1.20.0
[v1.19.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.18.0...v1.19.0
[v1.18.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.17.0...v1.18.0
[v1.17.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.16.0...v1.17.0
[v1.16.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.15.0...v1.16.0
[v1.15.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.14.0...v1.15.0
[v1.14.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.13.0...v1.14.0
[v1.13.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.12.0...v1.13.0
[v1.12.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.11.0...v1.12.0
[v1.11.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.10.0...v1.11.0
[v1.10.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.9.1...v1.10.0
[v1.9.1]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.9.0...v1.9.1
[v1.9.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.8.0...v1.9.0
[v1.8.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.7.0...v1.8.0
[v1.7.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.6.0...v1.7.0
[v1.6.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.4.1...v1.6.0
[v1.4.1]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.5.0...v1.4.1
[v1.5.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.5.1...v1.5.0
[v1.5.1]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.4.0...v1.5.1
[v1.4.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.3.0...v1.4.0
[v1.3.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.2.0...v1.3.0
[v1.2.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.0.4...v1.1.0
[v1.0.4]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.0.3...v1.0.4
[v1.0.3]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.0.2...v1.0.3
[v1.0.2]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.0.1...v1.0.2
[v1.0.1]: https://github.com/terraform-aws-modules/terraform-aws-vpc/compare/v1.0.0...v1.0.1
