terraform {
  backend "s3" {
    bucket         = "cheese-tfstate-prod-jsvr"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cheese-tf-lock"
    encrypt        = true
  }
}