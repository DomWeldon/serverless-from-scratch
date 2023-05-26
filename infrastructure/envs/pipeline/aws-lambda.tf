# IAM roles required for Lambda
data "aws_iam_policy_document" "sts" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy" "lambda_vpc_ac" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy_document" "exec" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
      "logs:GetLogEvents",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "lambda:GetFunction",
    ]

    resources = [
      aws_lambda_function.api.arn,
    ]
  }
}

resource "aws_iam_role" "execution" {
  name               = "${terraform.workspace}-api-exec"
  assume_role_policy = data.aws_iam_policy_document.sts.json
}


# actual lambda function
resource "aws_lambda_function" "api" {
  description = "AWS Lambda for API"
  role        = aws_iam_role.execution.arn

  image_uri    = "${var.image_url}:${terraform.workspace}"
  package_type = "Image"

  function_name = "${terraform.workspace}-api-handler"
  timeout       = 5
  memory_size   = 128
  publish       = true

  environment {
    variables = {
      ROOT_PATH = "/${terraform.workspace}"
    }
  }

  image_config {
    command = [var.api_entrypoint]
  }
}