
# ECS-Terraform-Codepipeline-Deployment

This repository contains the Terraform configuration to deploy a Flask application on Amazon ECS using AWS resources. The application displays the hostname and IP address of the running container.

## Prerequisites

Before you begin, make sure you have the following:

1.  [Terraform](https://www.terraform.io/) installed on your local machine. I recommend using the latest stable version.
    
2.  AWS CLI installed and configured with the necessary credentials and profiles.
    
3.  Docker container image for your Flask application pushed to an Amazon ECR repository. The CodePipeline will handle the build and push process automatically.
    
4.  **Important**: CodeBuild Role with "AmazonEC2RegistryPowerUser" Policy
    
    To enable CodeBuild to pull Docker images from Amazon ECR, it requires appropriate permissions. For this project, the CodeBuild role must be attached with the "AmazonEC2RegistryPowerUser" policy. This policy grants the necessary permissions for CodeBuild builders to pull Docker images from the specified ECR repositories. Ensure that the CodeBuild role has this policy attached to avoid any issues during the build and deployment process.
    

## Terraform Cloud Workspace

This Terraform configuration utilizes Terraform Cloud workspaces for isolation and easier management. The workspace name is set to `"<your-backend-here>"` at `terraform.tf`. If you are running this configuration in Terraform Cloud, ensure you have created the workspace with the correct name.

* Also validate that env variable `TF_CLOUD_ORGANIZATION` is set correctly to your terraform cloud organization name with export `TF_CLOUD_ORGANIZATION=<your-cloud-name>`.

```terraform {
  cloud {
    workspaces {
      name = "<your-backend-here>"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.45.0"
    }
  }
}
```

## Application Details

The application consists of the following files:

1.  **src/app.py**: This file contains the Flask application code. It displays the hostname and IP address of the running container.
    
2.  **src/Dockerfile**: This Dockerfile is used to build the Docker container image for the Flask application.
    
3.  **templates/index.html**: This HTML template is rendered by the Flask application to display the hostname and IP address.
    

## CodePipeline Build Specification

The repository includes a `buildspec.yml` file, which defines the build and deployment process for the application using AWS CodePipeline and CodeBuild.

## Deployment Steps

To deploy the application, follow these steps:

1.  Switch the Terraform backend configuration as described above.
    
2.  Initialize Terraform by running the following command:
    
-   `terraform init` 
    
-   Create an execution plan by running:
    
-   `terraform plan` 
    
    Review the plan to ensure it matches your expectations.
    
-   Apply the changes to create the resources:
    

3.  `terraform apply` 
    
    Type "yes" when prompted to confirm the changes.
    
4.  Once the deployment is complete, Terraform will output the public IP address of the deployed application.


5. For the pipeline impelmentation, use this guide [Official AWS Guide for ECS Deployment with CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/ecs-cd-pipeline.html)
    

## Cleaning Up

To clean up and destroy the resources created by Terraform, run:

`terraform destroy --auto-approve` 

Type "yes" when prompted to confirm the destruction of resources.

Feel free to reach out if you have any questions or need further assistance!
# ECS-NodeJS-MongoDB-Terraform
