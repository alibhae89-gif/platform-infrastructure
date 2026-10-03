terraform {
  backend "s3" {
    bucket         = "alibhae-platform-tf-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "platform-tf-locks"
    encrypt        = true
  }
}
