data "aws_caller_identity" "current" {}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "forgejo-terraform-state-bucket-s3"
    key    = "terraform-ecr/terraform.tfstate"
    region = "eu-central-1"
  }
}

module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  common_tags          = var.common_tags
}

module "eks_admin" {
  source = "./modules/iam/eks_admin"
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15.4"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  enable_irsa                          = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = ["91.214.208.166/32"]

  eks_managed_node_groups = {
    default = {
      min_size       = 2
      max_size       = 3
      desired_size   = 2
      instance_types = ["t3.micro"]
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = module.eks_admin.eks_admin_role_arn
      username = "eks-admin"
      groups   = ["system:masters"]
    }
  ]

  providers = {
    kubernetes = kubernetes
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS PostgreSQL instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow PostgreSQL access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.rds_allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.project_name}-rds-sg" },
    var.common_tags
  )
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = module.vpc.private_subnet_ids

  tags = merge(
    { Name = "${var.project_name}-rds-subnet-group" },
    var.common_tags
  )
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  identifier              = "${var.project_name}-rds"
  engine                  = "postgres"
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = "gp2"
  port                    = 5432
  family                  = var.family
  db_name                 = var.db_name
  username                = var.db_master_username
  password                = var.db_master_password
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  backup_retention_period = var.backup_retention_period
  deletion_protection     = false
  create_random_password  = false

  create_db_subnet_group = false
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  monitoring_interval    = 30
  create_monitoring_role = true
  monitoring_role_name   = "${var.project_name}-rds-monitoring-role"

  tags = merge(
    { Name = "${var.project_name}-rds" },
    var.common_tags
  )
}

