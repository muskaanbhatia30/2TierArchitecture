terraform {
  backend "s3" {
    bucket         = "statetfbucket"
    key            = "terraformfile/terraform.tfstate"
    region         = "us-east-1"
  }
}

