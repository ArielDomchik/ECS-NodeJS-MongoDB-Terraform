variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "container_image_url" {
  description = "URL of the container image"
  type        = string
  default     = "646360616404.dkr.ecr.us-east-1.amazonaws.com/arieldomchik:latest"
}

variable "db_image_url" {
  description = "URL of DB image"
  type        = string
  default     = "bitnami/mongodb"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "vpc"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "cluster"
}

variable "ecs_task_family" {
  description = "Name of the ECS task family"
  type        = string
  default     = "nodejs-mongodb-task"
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "nodejs-mongodb-service"
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "octopus-lb"
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
  default     = "octopus-target-group"
}


variable "security_group_name_lb" {
  description = "Name of the security group for the load balancer"
  type        = string
  default     = "octopus-alb-security-group"
}

variable "security_group_name_task" {
  description = "Name of the security group for the ECS task"
  type        = string
  default     = "octopus-task-security-group"
}

