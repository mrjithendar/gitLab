terraform {
  backend "s3" {
    bucket = "jithendardharmapuri"
    key    = "terraform/gitlab.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "gitops" {
  backend = "s3"
  config = {
    bucket = "jithendardharmapuri"
    key    = "terraform/gitops.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ekscluster" {
  backend = "s3"
  config = {
    bucket = "jithendardharmapuri"
    key    = "terraform/ekscluster.tfstate"
    region = "us-east-1"
  }
}