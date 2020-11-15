locals {
  namespace   = "useast1d"
  app_role    = "vpc"
  region      = "us-east-1"
  lob         = "it_operations"
  team        = "web_hosting"
  environment = "development"

  default_tags = {
    namespace : local.namespace,
    app_role : local.app_role,
    lob : local.lob,
    team : local.team,
    environment : local.environment
  }
}
