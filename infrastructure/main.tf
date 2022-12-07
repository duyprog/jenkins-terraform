terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = "10.5.0.0/16"
  public_subnets = ["10.5.0.0/24", "10.5.1.0/24"]
  env            = "production"

}