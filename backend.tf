terraform {
  backend "s3" {
    bucket = "sprigh-three-tier"
    dynamodb_table = "shoppr-tfstate-locking"
    key = "terraform/python-app-eks.tfstate"
    region = "us-east-1"
    encrypt = true 
  }
}
