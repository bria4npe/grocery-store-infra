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
    key          = "grocery-store/production/terraform.tfstate"
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
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  single_nat_gateway = false
  tags               = local.tags
}

module "ecr" {
  source = "../../modules/ecr"

  project  = var.project
  services = ["frontend"]
  tags     = local.tags
}

module "eks" {
  source = "../../modules/eks"

  project      = var.project
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
  instance_types = ["t3.medium", "t3.large", "t3a.medium"]
  min_size       = 2
  max_size       = 6
  desired_size   = 2
  tags           = local.tags
}
