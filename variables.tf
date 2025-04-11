variable "environment" {}
variable "region" {}
variable "tags" {
  default = {
    environment = var.environment
    costcenter  = "devops"
    owner       = "team-infra"
  }
}
