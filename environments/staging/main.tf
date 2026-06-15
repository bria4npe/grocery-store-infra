terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "grocery-store-terraform-state"
    key          = "grocery-store/staging/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project            = var.project
  environment        = var.environment
  azs                = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets    = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets     = ["10.1.101.0/24", "10.1.102.0/24"]
  single_nat_gateway = true
  tags               = local.tags
}

module "ecr" {
  source = "../../modules/ecr"

  project  = var.project
  services = ["frontend"]
  suffix   = "-stg"
  tags     = local.tags
}

module "eks" {
  source = "../../modules/eks"

  project      = var.project
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
  min_size     = 1
  max_size     = 3
  desired_size = 1
  tags         = local.tags
}
