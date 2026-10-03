variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC Provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the EKS OIDC Issuer"
  type        = string
}

variable "namespace" {
  description = "Kubernetes Namespace for the ServiceAccount"
  type        = string
}

variable "service_account" {
  description = "Kubernetes ServiceAccount name"
  type        = string
}

variable "policy_arn" {
  description = "ARN of the AWS IAM Policy to attach to the role"
  type        = string
  default     = ""
}
