locals {
  get_model_lambda_name = "get_model_lambda"
}

# IAM role for Lambda execution
data "aws_iam_policy_document" "get_model_lambda_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "get_model_lambda_basic_execution" {
  role       = aws_iam_role.get_model_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "get_model_lambda_custom_policy" {
  role       = aws_iam_role.get_model_lambda_role.name
  policy_arn = aws_iam_policy.get_model_lambda_custom_policy.arn
}

resource "aws_iam_policy" "get_model_lambda_custom_policy" {
  name        = "get_model_lambda_custom_policy"
  policy      = data.aws_iam_policy_document.get_model_lambda_custom_policy_document.json
}

data "aws_iam_policy_document" "get_model_lambda_custom_policy_document" {
  statement {
    sid = "AllowS3Access"
    actions = [
      "sagemaker:ListModelPackages",
      "sagemaker:DescribeModelPackage",
    ]
    resources = [
      "arn:aws:sagemaker:us-east-1:557690605188:model-package/*",
    ]
  }
}

resource "aws_iam_role" "get_model_lambda_role" {
  name               = local.get_model_lambda_name
  assume_role_policy = data.aws_iam_policy_document.get_model_lambda_assume_role_policy.json
}

resource "aws_cloudwatch_log_group" "get_model_lambda_log_group" {
  name              = "/aws/lambda/${local.get_model_lambda_name}"
  retention_in_days = 14
}

data "archive_file" "get_model_lambda_zip" {
  type        = "zip"
  source_dir = "../abalone-inference/get-model-lambda/code"
  output_path = "../abalone-inference/get-model-lambda/lambda.zip"
}

resource "aws_lambda_function" "get_model_lambda" {
  function_name = local.get_model_lambda_name
  role          = aws_iam_role.get_model_lambda_role.arn
  runtime       = "python3.12"
  filename      = data.archive_file.get_model_lambda_zip.output_path
  source_code_hash = data.archive_file.get_model_lambda_zip.output_base64sha256
  handler       = "lambda.handler"

  depends_on = [
    aws_cloudwatch_log_group.get_model_lambda_log_group
  ]
}