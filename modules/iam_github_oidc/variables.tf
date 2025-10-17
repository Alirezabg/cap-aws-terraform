variable "github_owner" {
  description = "GitHub organization or user that owns the repository."
  type        = string
}

variable "github_repository" {
  description = "Name of the GitHub repository that will assume the role."
  type        = string
}

variable "role_name" {
  description = "Name to assign to the IAM role used by GitHub Actions."
  type        = string
  default     = "github-actions-ecr"
}

variable "oidc_provider_url" {
  description = "URL for the GitHub Actions OIDC provider."
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "oidc_thumbprint" {
  description = "Thumbprint for the GitHub Actions OIDC provider."
  type        = string
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1"
}

variable "allowed_ecr_arns" {
  description = "List of ECR repository ARNs that GitHub Actions workflows can access."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to created IAM resources."
  type        = map(string)
  default     = {}
}
