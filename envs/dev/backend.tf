terraform {
  backend "s3" {
    bucket         = "cheese-tfstate-prod"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
