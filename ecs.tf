module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  name   = "producao"

  container_insights = true
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
    }
  ]
}

resource "aws_ecs_task_definition" "minimal_api_task_defination" {
  family                   = "minimal-api-task-defination"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.minimal_api_iam_role.arn
  container_definitions = jsonencode(
    [
      {
        "name"      = "producao"
        "image"     = "asrsantana/minimal-web-api:v1"
        "cpu"       = 256
        "memory"    = 512
        "essential" = true
        "portMappings" : [{
          "containerPort" = 5000
          "hostPort"      = 5000
        }]
      }
  ])
}

resource "aws_ecs_service" "minimal_api_service" {
  name            = "minimal-api-service"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.minimal_api_task_defination.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.target.arn
    container_name   = "producao"
    container_port   = 5000
  }

  network_configuration {
    subnets         = module.vpc.public_subnets
    security_groups = [aws_security_group.private_minimal-api-sg.id]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}
