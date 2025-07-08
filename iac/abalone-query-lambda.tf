locals {
  abalone_query_lambda_name = "abalone_query_lambda"
}

# IAM role for Lambda execution
data "aws_iam_policy_document" "abalone_query_lambda_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "abalone_query_lambda_custom_policy" {
  role       = aws_iam_role.abalone_query_lambda_role.name
  policy_arn = aws_iam_policy.abalone_query_lambda_custom_policy.arn
}

resource "aws_iam_policy" "abalone_query_lambda_custom_policy" {
  name        = "abalone_query_lambda_custom_policy"
  policy      = data.aws_iam_policy_document.abalone_query_lambda_custom_policy_document.json
}

data "aws_iam_policy_document" "abalone_query_lambda_custom_policy_document" {
  statement {
    sid    = "AllowAthenaQuery"
    effect = "Allow"
    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryExecution",
      "athena:GetQueryResults"
    ]
    resources = ["arn:aws:athena:${var.region}:${var.account_id}:workgroup/*"]
  }

  statement {
    sid    = "AllowAthenaS3Operations"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.sm_poc_bucket.arn}/",
      "${aws_s3_bucket.sm_poc_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_role" "abalone_query_lambda_role" {
  name               = local.abalone_query_lambda_name
  assume_role_policy = data.aws_iam_policy_document.abalone_query_lambda_assume_role_policy.json
}

resource "aws_cloudwatch_log_group" "abalone_query_lambda_log_group" {
  name              = "/aws/lambda/${local.abalone_query_lambda_name}"
  retention_in_days = 14
}

data "archive_file" "abalone_query_lambda_zip" {
  type        = "zip"
  source_dir = "../abalone-inference/abalone-query-lambda/code"
  output_path = "../abalone-inference/abalone-query-lambda/lambda.zip"
}

resource "aws_lambda_function" "abalone_query_lambda" {
  function_name = local.abalone_query_lambda_name
  role          = aws_iam_role.abalone_query_lambda_role.arn
  runtime       = "python3.12"
  filename      = data.archive_file.abalone_query_lambda_zip.output_path
  source_code_hash = data.archive_file.abalone_query_lambda_zip.output_base64sha256
  handler       = "lambda.handler"

  depends_on = [
    aws_cloudwatch_log_group.abalone_query_lambda_log_group
  ]
}