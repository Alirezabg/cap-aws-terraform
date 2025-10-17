resource "aws_ecr_repository" "java_app" {
  name                 = "capstone-java-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project     = "capstone"
    Environment = "test"
    Terraform   = "true"
  }
}

resource "aws_ecr_lifecycle_policy" "java_app" {
  repository = aws_ecr_repository.java_app.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 10
      }
      action = {
        type = "expire"
      }
    }]
  })
}

# IAM Policy for ECR Push permissions
resource "aws_iam_policy" "ecr_push" {
  name        = "github-actions-ecr-push-policy"
  description = "Allow GitHub Actions to push images to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "GetAuthorizationToken"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Sid    = "ManageRepositoryContents"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = aws_ecr_repository.java_app.arn
      }
    ]
  })

  tags = {
    Project     = "capstone"
    Environment = "test"
    Terraform   = "true"
  }
}

resource "aws_iam_role" "github_actions_ecr" {
  name        = "github-actions-ecr-push-role"
  description = "Role for GitHub Actions to push images to ECR"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::895636586366:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:batuncer/OnlineShop-backend:*"
          }
        }
      }
    ]
  })

  tags = {
    Project     = "capstone"
    Environment = "test"
    Terraform   = "true"
  }
}

# Attach ECR push policy to GitHub Actions role
resource "aws_iam_role_policy_attachment" "github_actions_ecr_push" {
  role       = aws_iam_role.github_actions_ecr.name
  policy_arn = aws_iam_policy.ecr_push.arn
}

# Outputs
output "ecr_repository_url" {
  description = "Full URL of the ECR repository"
  value       = aws_ecr_repository.java_app.repository_url
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.java_app.name
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.java_app.arn
}

output "github_actions_role_arn" {
  description = "IAM Role ARN for GitHub Actions to assume"
  value       = aws_iam_role.github_actions_ecr.arn
}

output "github_actions_role_name" {
  description = "IAM Role name for GitHub Actions"
  value       = aws_iam_role.github_actions_ecr.name
}