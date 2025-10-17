locals {
  cluster_name = "cap-test-eks"
  vpc_cidr     = "10.10.0.0/16"
  azs          = ["eu-west-2a", "eu-west-2b"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.cluster_name}-vpc"
  cidr = local.vpc_cidr
  azs  = local.azs

  public_subnets = [
    "10.10.0.0/19",
    "10.10.32.0/19",
  ]
  private_subnets = [   
  "10.10.64.0/19",
  "10.10.96.0/19",
]


  enable_nat_gateway = true
  single_nat_gateway = true  

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
  private_subnet_tags = {
  "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  "kubernetes.io/role/internal-elb"             = "1"
}


  tags = {
    Project     = "capstone"
    Environment = "test"
    Terraform   = "true"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    spot_general = {
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

      desired_size = 1
      min_size     = 1
      max_size     = 2

      disk_size = 20

      labels = {
        workload = "general"
      }

      tags = {
        Project     = "capstone"
        Environment = "test"
        Terraform   = "true"
      }
    }
  }

  enable_irsa                   = true
  create_cluster_security_group = true
  create_node_security_group    = true
  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
  }

  tags = {
    Project     = "capstone"
    Environment = "test"
    Terraform   = "true"
  }
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
