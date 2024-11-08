terraform {
  backend "s3" {
    bucket         = "database-terraform-state"
    key            = "global/s3/network.tfstate"
    region         = "us-west-2"
    dynamodb_table = "database-terrafrom-state-locks"
  }
}