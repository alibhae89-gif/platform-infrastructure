# 1. Instantiate VPC Module
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr             = var.vpc_cidr
  cluster_name         = var.cluster_name
  availability_zones   = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

# 2. Instantiate EKS Module
module "eks" {
  source = "../../modules/eks"

  cluster_name        = var.cluster_name
  cluster_version     = "1.31"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  node_instance_types = ["t3.medium"]
  desired_capacity    = 2
  min_capacity        = 1
  max_capacity        = 4
}

# 3. Create TLS Certificate & OIDC Provider for IRSA
data "tls_certificate" "eks" {
  url = module.eks.cluster_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = module.eks.cluster_oidc_issuer_url
}

# 4. IRSA for EBS CSI Driver (Storage Provisioning)
module "ebs_csi_irsa" {
  source = "../../modules/irsa"

  role_name         = "${var.cluster_name}-ebs-csi-role"
  oidc_provider_arn = aws_iam_openid_connect_provider.eks.arn
  oidc_provider_url = module.eks.cluster_oidc_issuer_url
  namespace         = "kube-system"
  service_account   = "ebs-csi-controller-sa"
  policy_arn        = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
