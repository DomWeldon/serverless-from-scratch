# Main CircleCI project
data "circleci_project" "main" {
  project_slug = var.repo_slug
}

locals {
  circleci_aws_credentials = {
    AWS_ACCESS_KEY_ID      = aws_iam_access_key.circleci.id
    AWS_SECRET_ACCESS_KEY  = aws_iam_access_key.circleci.secret
    AWS_DEFAULT_REGION     = var.default_region
    AWS_ECR_REGISTRY_ID    = aws_ecr_repository.api.registry_id
    AWS_ECR_REPOSITORY_URL = aws_ecr_repository.api.repository_url
    # pass some values to pipeline config
    TF_VAR_image_url       = aws_ecr_repository.api.repository_url
    TF_VAR_api_execution_arn   = aws_apigatewayv2_api.main.execution_arn
    TF_VAR_api_id   = aws_apigatewayv2_api.main.id

  }
}

# we can put the above environment variables into CI automatically
resource "circleci_environment_variable" "main" {
  for_each = local.circleci_aws_credentials

  project_slug = data.circleci_project.main.project_slug
  name         = each.key
  value        = each.value
}