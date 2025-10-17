output "eks_cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "API server endpoint for the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Certificate authority data required to authenticate to the cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "ecr_repository_url" {
  description = "URL of the ECR repository used by the application."
  value       = aws_ecr_repository.application.repository_url
}

output "github_actions_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions workflows."
  value       = module.github_actions_oidc.role_arn
}
