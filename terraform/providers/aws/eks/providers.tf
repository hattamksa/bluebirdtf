terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region  = "ap-southeast-1" 
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}