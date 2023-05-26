# serverless-from-scratch

Serverless from scratch example with Terraform and python


## Getting Started

1. Install Terraform using tfenv, and set a default version.
2. Install aws-vault, and configure a user in your AWS account that you can use with it. Alternative AWS Auth setups may require tools such as `saml2aws` or similar, depending on your organization's setup.

### 1. Apply the Global Configuration

This will build the global infrastructure, including the following main compontnets:

* A common ECR to store images
* A route 53 zone, with a namecheap domain pointing to it
* An ACM certificate for this domain
* A common AWS API Gateway using this domain

    cd infrastructure/envs/global
    aws-vault exec pyconitalia2023 -- terraform init
    aws-vault exec pyconitalia2023 --no-session -- terraform apply
