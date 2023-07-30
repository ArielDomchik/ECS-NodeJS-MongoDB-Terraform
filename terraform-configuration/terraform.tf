terraform {
  cloud {
    workspaces {
      name = "octopus-ecs"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.45.0"
    }
  }
}
