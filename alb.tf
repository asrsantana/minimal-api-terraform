
resource "aws_lb" "minimal_api_lb" {
  name               = "minimal-api-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_minimal_api_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.minimal_api_lb.arn
  port              = "5000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
}

# Target Group para o Load Balancer
resource "aws_lb_target_group" "target" {
  name        = "target-group-lb"
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

output "IP" {
  value = aws_lb.minimal_api_lb.dns_name
}
