terraform {
  backend "s3" {
    bucket         = "bluebird-bucket"
    key            = "tf/vpc/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "bluebird-tf-lock"
  }
}
