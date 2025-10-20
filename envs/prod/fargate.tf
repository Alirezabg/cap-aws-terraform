
resource "aws_ecs_cluster" "main" {
  name = "${local.cluster_name}-fargate"

  tags = {
    Project     = "capstone"
    Environment = "test"
    Terraform   = "true"
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${local.cluster_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "${local.cluster_name}-container"
      image     = aws_ecr_repository.java_app.repository_url
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])

  tags = {
    Project     = "capstone"
    Environment = "test"
    Terraform   = "true"
  }
}

resource "aws_ecs_service" "main" {
  name            = "${local.cluster_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.vpc.public_subnets
    security_groups = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "${local.cluster_name}-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.http]

  tags = {
    Project     = "capstone"
    Environment = "test"
    Terraform   = "true"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${local.cluster_name}-ecs-task-execution-role"

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

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${local.cluster_name}-ecs-tasks-sg"
  description = "Allow inbound traffic to ECS tasks"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
        Terraform   = "true"
      }
    }
    
    resource "aws_lb" "main" {
      name               = "${local.cluster_name}-alb"
      internal           = false
      load_balancer_type = "application"
      security_groups    = [aws_security_group.ecs_tasks.id]
      subnets            = module.vpc.public_subnets
    
      tags = {
        Project     = "capstone"
        Environment = "test"
        Terraform   = "true"
      }
    }
    
    resource "aws_lb_target_group" "main" {
      name        = "${local.cluster_name}-tg"
      port        = 8080
      protocol    = "HTTP"
      vpc_id      = module.vpc.vpc_id
      target_type = "ip"
    
      health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 15
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
      }
    
      tags = {
        Project     = "capstone"
        Environment = "test"
        Terraform   = "true"
      }
    }
    
    resource "aws_lb_listener" "http" {
      load_balancer_arn = aws_lb.main.arn
      port              = 80
      protocol          = "HTTP"
    
      default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.main.arn
      }
    }
    
    
