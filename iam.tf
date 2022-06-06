resource "aws_iam_role" "minimal_api_iam_role" {
  name = "minimal-api-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com",
          "ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "minimal_api_iam_instance_profile" {
  name = "minimal-api-iam-instance-profile"
  role = aws_iam_role.minimal_api_iam_role.name
}
