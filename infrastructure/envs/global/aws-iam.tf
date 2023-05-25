# create a user for CircleCI
resource "aws_iam_user" "circleci" {
  name = "${terraform.workspace}-circleci"
}

# with API access
resource "aws_iam_access_key" "circleci" {
  user = aws_iam_user.circleci.name
}

# Make CircleCI user an admin
resource "aws_iam_user_policy_attachment" "admin_access" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  user       = aws_iam_user.circleci.name
}