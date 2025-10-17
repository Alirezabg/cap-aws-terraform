locals {
  ecr_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_ecr_repository" "application" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.ecr_tags
}

module "github_actions_oidc" {
  source = "../../modules/iam_github_oidc"

  github_owner       = var.github_owner
  github_repository  = var.github_repository
  role_name          = var.github_oidc_role_name
  allowed_ecr_arns   = [aws_ecr_repository.application.arn]
  tags               = local.ecr_tags
}
