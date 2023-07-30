# Task 1
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = var.vpc_name

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

# Task 2
resource "aws_ecs_cluster" "my_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRoleAriel"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecsTaskExecutionRole.name
}

resource "aws_iam_policy_attachment" "efs_full_access" {
  name       = "EFSFullAccessAttachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
  roles      = [aws_iam_role.ecsTaskExecutionRole.name]
}

resource "aws_efs_file_system" "mongodb_efs" {
  creation_token = "mongodb-efs"
}

resource "aws_efs_mount_target" "mongodb_mount_target" {
  file_system_id = aws_efs_file_system.mongodb_efs.id
  subnet_id      = module.vpc.private_subnets[0] # Choose one of the private subnets for EFS mount target
  security_groups = [aws_security_group.hello_world_task.id]
}

resource "aws_efs_mount_target" "mongodb_mount_target2" {
  file_system_id = aws_efs_file_system.mongodb_efs.id
  subnet_id      = module.vpc.private_subnets[1] # Choose one of the private subnets for EFS mount target
  security_groups = [aws_security_group.hello_world_task.id]
}

resource "aws_security_group_rule" "ecs_loopback_rule" {
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "-1"
  self                      = true
  description               = "Loopback"
  security_group_id         = aws_security_group.hello_world_task.id
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "nodejs-mongodb-task"
  requires_compatibilities = ["FARGATE"]  # Use Fargate launch type for serverless containers
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024

  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = jsonencode([
    {
      name      = "nodejs-application"
      image     = "public.ecr.aws/x3n7f5y0/arieldomchik:ecs-test"  # Replace with your Node.js Docker image
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ],
      environment = [
        {
          name  = "MONGODB_HOST"
          value = "mongodb"  # Use container name as the hostname to connect to MongoDB
        }
      ]
    },
    {
      name      = "mongodb"
      image     = "bitnami/mongodb"
      essential = true
      portMappings = [
        {
          containerPort = 27017
          hostPort      = 27017
        }
      ],
      mountPoints = [
        {
          sourceVolume  = "mongodb-data"
          containerPath = "/data/db"  # Mount persistent volume for MongoDB data
        }
      ]
    }
  ])

  volume {
    name = "mongodb-data"

    efs_volume_configuration {
      file_system_id = aws_efs_file_system.mongodb_efs.id
      root_directory = "/"  # Replace this with the desired directory path in EFS
    }
  }
}

resource "aws_security_group" "lb" {
  name   = var.security_group_name_lb
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb" "default" {
  name            = var.lb_name
  subnets         = module.vpc.public_subnets
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "hello_world" {
  name        = var.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
}


resource "aws_lb_listener" "hello_world" {
  load_balancer_arn = aws_lb.default.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.hello_world.arn
    type             = "forward"
  }
}

resource "aws_security_group" "hello_world_task" {
  name   = var.security_group_name_task
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 27017
    to_port         = 27017
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_ecs_service" "hello_world_task" {
  name            = "nodejs-mongodb-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  launch_type     = "FARGATE"  # Use Fargate launch type for serverless containers
  desired_count   = 2         # Number of containers to run

  network_configuration {
    subnets         = module.vpc.private_subnets
    assign_public_ip = false
    security_groups  = [aws_security_group.hello_world_task.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.hello_world.arn
    container_name   = "nodejs-application"
    container_port   = 3000
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
}

# Auto Scaling (Note: Auto Scaling for Fargate tasks based on CPU utilization is not supported as of my knowledge cutoff in September 2021)
