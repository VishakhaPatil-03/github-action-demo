# -----------------------------------------
# Terraform Backend Configuration
# -----------------------------------------

terraform {
  backend "local" {
    path = "/opt/terraform-state/github-action-demo/terraform.tfstate"
  }
}
