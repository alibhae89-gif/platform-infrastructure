output "cluster_endpoint" {
  description = "EKS Cluster Control Plane Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "Run this command to update local kubeconfig for the EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "ebs_csi_irsa_role_arn" {
  description = "IAM Role ARN for EBS CSI Driver"
  value       = module.ebs_csi_irsa.role_arn
}
