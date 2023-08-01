
#  Node.js and MongoDB Application on AWS ECS Fargate with CodePipeline

This application is a serverless containerized application built with Node.js and MongoDB, running on AWS Elastic Container Service (ECS) Fargate. It leverages AWS Elastic File System (EFS) to persist data for the MongoDB database. The project also includes a pipeline using AWS CodePipeline to automate the build and deployment process.

## Overview

The application is a simple web service built with Node.js that interacts with a MongoDB database. It retrieves the quantity of apples from the database and displays it when accessed.

## Architecture

The Octopus application is deployed as two containers on AWS ECS Fargate:

1.  **Node.js Application Container**: This container hosts the Node.js web service that serves the application. It communicates with the MongoDB container to retrieve data.
    
2.  **MongoDB Container**: This container runs the MongoDB database to store and manage the application data.
    

The containers share the network using the `awsvpc` mode, and data persistence for MongoDB is achieved using AWS Elastic File System (EFS).


## Prerequisites

Before setting up the Octopus application and pipeline, make sure you have the following prerequisites:

-   An AWS account with appropriate permissions to create ECS cluster, EFS volumes, security groups, IAM roles and CodePipeline.
-   Docker installed on your local machine for building and testing containers.
-   Terraform installed on your local machine for infrastructure provisioning.

## Terraform Backend

The Terraform configuration for this project uses Terraform Cloud as the backend to manage state. To change the backend settings, modify the `terraform` block in the `terraform.tf` file:

```
terraform {
  cloud {
    workspaces {
      name = "<your-backend-here>"
    }
  }
} 
```
## Getting Started

Follow the steps below to deploy the Octopus application on AWS ECS Fargate:

1.  Clone this repository:

`git clone https://github.com/ArielDomchik/ECS-NodeJS-MongoDB-Terraform` 

2.  Set up the AWS credentials:
```
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
```
- Make sure to change the region in `variables.tf` : 
```variable "region" {
  description = "AWS region"
  type        = string
  default     = "<your-region-here>"
}
```
 

3.  Deploy the infrastructure using Terraform:

```
terraform init

terraform apply -target=module.vpc --auto-approve

terraform apply -target=aws_efs_file_system.mongodb_efs -target=aws_efs_mount_target.mongodb_mount_target -target= aws_efs_mount_target.mongodb_mount_target2 --auto-approve

terraform apply --auto-approve
```
** Note : EFS Needs to be provisioned first to be used by the ECS Task.

## Pipeline Setup

For pipeline implementation, use the AWS CodePipeline guide [here](https://docs.aws.amazon.com/codepipeline/latest/userguide/ecs-cd-pipeline.html) to set up the pipeline with AWS CodeBuild and AWS ECR integration.

## Usage

After the infrastructure is provisioned, any changes pushed to your GitHub repository will automatically trigger the pipeline to build and deploy the updated container images to the ECS service. Access the application using the load balancer's DNS name or IP address. You can find the load balancer's endpoint in the AWS Management Console.

## Terraform Configuration

The infrastructure for the application is defined using Terraform. The Terraform configuration in the `main.tf` file provisions the VPC and networking components, ECS cluster, EFS file system, security groups, IAM Roles ,and ECS service with task definition. 

## Destroying Resources

To destroy the resources created by Terraform and remove all the infrastructure, -   Run the following command: `terraform destroy --auto-approve`
Note: Destroying the resources will permanently delete all the infrastructure and data associated with the application. Proceed with caution.

----------

