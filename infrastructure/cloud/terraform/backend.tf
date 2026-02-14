terraform {
  backend "s3" {
    bucket         = "<YOUR_S3_BUCKET_NAME>"
    key            = "eks/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "<YOUR_DYNAMODB_TABLE>"
    encrypt        = true
  }
}
