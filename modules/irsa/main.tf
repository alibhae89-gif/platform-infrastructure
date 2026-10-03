locals {
  # Strip 'https://' from the OIDC URL for trust policy matching
  oidc_url_strip = replace(var.oidc_provider_url, "https://", "")
}

resource "aws_iam_role" "irsa" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_url_strip}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account}",
            "${local.oidc_url_strip}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "irsa" {
  count      = var.policy_arn != "" ? 1 : 0
  role       = aws_iam_role.irsa.name
  policy_arn = var.policy_arn
}
