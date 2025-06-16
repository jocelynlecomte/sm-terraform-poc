terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # the source from terraform
      version = ">= 5.9"        # uses pessimistic constraint
    }
  }
  /*backend "s3" {
    bucket = "sagemaker-remote-state" # name of the bucket
    region = "us-east-1" # default region
    key     = "sm-poc/terraform.tfstate"
    use_lockfile = true # use a lock file to prevent concurrent writes
    profile = "personal-tf" # personal profile
  }*/
}

provider "aws" {
  profile = "personal-tf"
  region  = "us-east-1"
}