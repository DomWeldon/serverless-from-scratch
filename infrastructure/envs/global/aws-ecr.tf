# ECR to store all API images
resource "aws_ecr_repository" "api" {
  name = "${var.project_name}-api"
}