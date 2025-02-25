data "terraform_remote_state" "vpc" {
  backend   = "s3"
  workspace = local.env

  config = {
    bucket = "bluebird-bucket"
    key    = "tf/vpc/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
