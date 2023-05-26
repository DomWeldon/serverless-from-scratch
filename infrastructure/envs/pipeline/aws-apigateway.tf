# create an integration for the lambda function we made
resource "aws_apigatewayv2_integration" "lambda" {

  api_id           = var.api_id
  integration_type = "AWS_PROXY"

  description        = "Lambda integration for ${terraform.workspace}"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.api.invoke_arn

  payload_format_version = "1.0"
}


# give API Gateway the right permission to invoke the lambda
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/*/*/*"
}

# create a catch all route
resource "aws_apigatewayv2_route" "app" {
  api_id    = var.api_id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

# create a stage
resource "aws_apigatewayv2_stage" "this" {
  api_id = var.api_id
  name   = terraform.workspace
}

# deploy the API
resource "aws_apigatewayv2_deployment" "example" {
  api_id      = var.api_id
  description = "Deployment for ${terraform.workspace}"

  lifecycle {
    create_before_destroy = true
  }
}