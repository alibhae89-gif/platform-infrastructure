output "role_arn" {
  description = "ARN of the created IAM Role for Service Account"
  value       = aws_iam_role.irsa.arn
}
