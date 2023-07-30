variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "container_image_url" {
  description = "URL of the container image"
  type        = string
  default     = "753392824297.dkr.ecr.eu-central-1.amazonaws.com/arieldomchik:latest"
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
  default     = "app-first-task"
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "app-first-service"
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "example-lb"
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
  default     = "example-target-group"
}

variable "task_container_name" {
  description = "Name of the ECS task container"
  type        = string
  default     = "app-first-container"
}

variable "security_group_name_lb" {
  description = "Name of the security group for the load balancer"
  type        = string
  default     = "example-alb-security-group"
}

variable "security_group_name_task" {
  description = "Name of the security group for the ECS task"
  type        = string
  default     = "example-task-security-group"
}

variable "autoscaler_name" {
  description = "Name of the autoscaler for service"
  type        = string
  default     = "ecs-service-scaling"
}
