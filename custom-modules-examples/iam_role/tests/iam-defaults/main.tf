module "iam_role" {
  source = "../../../../custom-modules-examples/iam_role"

  role_name = "iam_role_tester"
  service   = "ec2"
}
