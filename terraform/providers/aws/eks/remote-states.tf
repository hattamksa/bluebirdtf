// Get vpc data from vpc terraform state
data "terraform_remote_state" "vpc" {
  backend   = "s3"
  workspace = local.env

  config = {
    bucket = "learning-bucket"
    key    = "tf/vpc/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

