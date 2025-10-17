variable "region" {
  description = "AWS region where the infrastructure will be provisioned."
  type        = string
  default     = "eu-west-2"
}

variable "project" {
  description = "Project name used for resource naming and tagging."
  type        = string
  default     = "cap"
}

variable "environment" {
  description = "Environment name used for resource naming and tagging."
  type        = string
  default     = "test"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository that stores application images."
  type        = string
  default     = "cap-application"
}

variable "github_owner" {
  description = "GitHub organization or user that owns the application repository."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository that builds and pushes images."
  type        = string
}

variable "github_oidc_role_name" {
  description = "IAM role name assumed by GitHub Actions for pushing to ECR."
  type        = string
  default     = "github-actions-ecr"
}
