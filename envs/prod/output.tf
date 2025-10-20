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

output "fargate_alb_dns_name" {
  description = "DNS name of the Fargate Application Load Balancer"
  value       = aws_lb.main.dns_name
}
