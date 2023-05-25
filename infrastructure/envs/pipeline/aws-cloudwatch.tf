resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${terraform.workspace}-api-handler"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name        = "${terraform.workspace}-api-handler-lambda-logging"
  path        = "/"
  description = "IAM policy for logging invocations"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.execution.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

data "aws_apigatewayv2_api" "api" {
    api_id = var.api_id
}

resource "aws_cloudwatch_log_group" "main" {
  name = "apigatewayv2/${data.aws_apigatewayv2_api.api.name}/${terraform.workspace}/execution"
}