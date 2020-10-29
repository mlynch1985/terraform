module "ec2_role" {
    source = "../modules/ec2_role"

    default_tags = var.default_tags
    region = var.region
    account_id = var.account_id
    role_name = "${var.default_tags.namespace}_wordpress"
}

module "alb" {
    source = "../modules/alb"

    default_tags = var.default_tags
    region = var.region
    vpc_id = var.vpc_id
    common_security_group = var.common_security_group
    subnets = var.public_subnets
    internal = false
}

module "asg" {
    source = "../modules/asg_linux"

    default_tags = var.default_tags
    vpc_id = var.vpc_id
    ec2_role = module.ec2_role
    instance_type = "c5.large"
    common_security_group = var.common_security_group
    user_data = filebase64("${path.module}/userdata.sh")
    asg_min = 1
    asg_max = 6
    asg_desired = 3
    health_check_type = "ELB"
    subnets = var.private_subnets
    target_group = module.alb.target_group
}
