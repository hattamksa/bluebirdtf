terraform {
  backend "s3" {
    bucket         = "learning-bucket"
    key            = "tf/vpc/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "learning-tf-lock"
  }
}
