resource "aws_sagemaker_pipeline" "simple_pipeline" {
  pipeline_name         = "simple-pipeline"
  pipeline_display_name = "simple-pipeline-display"
  pipeline_description  = "Simple SageMaker Pipeline for POC"
  role_arn              = aws_iam_role.sm_role.arn

  pipeline_definition = templatefile("${path.module}/resources/simple-pipeline.json.tftpl", {
    bucket = aws_s3_bucket.sm_poc_bucket.bucket,
  })
}

resource "aws_sagemaker_pipeline" "housing_pipeline" {
  pipeline_name         = "housing-pipeline"
  pipeline_display_name = "housing-pipeline-display"
  pipeline_description  = "Housing SageMaker Pipeline for POC"
  role_arn              = aws_iam_role.sm_role.arn

  pipeline_definition = templatefile("${path.module}/resources/housing-pipeline.json.tftpl", {
    bucket = aws_s3_bucket.sm_poc_bucket.bucket,
    execution_role_arn = aws_iam_role.sm_role.arn,
    base_container_dir = "/opt/ml/processing",
  })
}

resource "aws_sagemaker_pipeline" "abalone_pipeline" {
  pipeline_name         = "abalone-pipeline"
  pipeline_display_name = "abalone-pipeline-display"
  pipeline_description  = "Abalone SageMaker Pipeline for POC"
  role_arn              = aws_iam_role.sm_role.arn

  pipeline_definition = templatefile("${path.module}/resources/abalone-pipeline.json.tftpl", {
    bucket = aws_s3_bucket.sm_poc_bucket.bucket,
    execution_role_arn = aws_iam_role.sm_role.arn,
    base_container_dir = "/opt/ml/processing",
  })
}

resource "aws_sagemaker_pipeline" "abalone_inference_pipeline" {
  pipeline_name         = "abalone-inference-pipeline"
  pipeline_display_name = "abalone-inference-pipeline-display"
  role_arn              = aws_iam_role.sm_role.arn

  pipeline_definition = templatefile("${path.module}/resources/abalone-inference-pipeline.json.tftpl", {
    bucket = aws_s3_bucket.sm_poc_bucket.bucket,
    execution_role_arn = aws_iam_role.sm_role.arn,
    base_container_dir = "/opt/ml/processing",
    get_model_url_function_arn = aws_lambda_function.get_model_lambda.arn,
  })
}
