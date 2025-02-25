terraform {
  backend "s3" {
    bucket         = "bluebird-bucket"       # Nama bucket S3 untuk menyimpan state file
    key            = "tf/ec2/terraform.tfstate" # Path ke state file di dalam bucket
    region         = "ap-southeast-1"       # Region bucket S3
    encrypt        = true                   # Enkripsi state file
    dynamodb_table = "terraform-lock"       # Nama tabel DynamoDB untuk state locking (opsional)
  }
}