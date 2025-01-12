terraform {
  backend "s3" {
    bucket = "sprigh-three-tier"
    dynamodb_table = "state-lock"
    key = "terraform/python-app-eks.tfstate"
    region = "us-east-1"
    encrypt = true 
  }
}
