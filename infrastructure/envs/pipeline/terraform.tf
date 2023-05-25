// Configure which providers we'll use
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  // backend where state is stored
  backend "s3" {
    # this has to be hardcoded
    bucket = "222127688838-pyconitalia2023-tfstate"
    key    = "serverless-from-scratch/pipeline/tfstate"
    region = "eu-west-2" # I live in London, sorry.
  }
}

// configure individual providers
provider "aws" {
  region = "eu-west-2"
}
