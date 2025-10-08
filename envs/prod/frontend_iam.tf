resource "aws_iam_role_policy" "frontend_s3_deploy" {
  name = "frontend-s3-deploy"
  role = aws_iam_role.github_actions_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::online-shop-cap-frontend-web-eu-west-2",
          "arn:aws:s3:::online-shop-cap-frontend-web-eu-west-2/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "github_actions_deploy" {
  name = "github-actions-deploy-frontend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:batuncer/OnlineShop-Frontend:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

