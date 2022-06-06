resource "aws_security_group" "alb_minimal_api_sg" {
  name   = "alb-minimal-api-sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "alb_minimal_api_sg_rule_in" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_minimal_api_sg.id
}

resource "aws_security_group_rule" "alb_minimal_api_sg_rule_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_minimal_api_sg.id
}

resource "aws_security_group" "private_minimal-api-sg" {
  name   = "private-minimal-api-sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "private_minimal_api_sg_rule_in" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.alb_minimal_api_sg.id
  security_group_id        = aws_security_group.private_minimal-api-sg.id
}

resource "aws_security_group_rule" "private_minimal_api_sg_rule_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_minimal-api-sg.id
}
