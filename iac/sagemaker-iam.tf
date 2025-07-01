resource "aws_iam_role" "sm_role" {
  name               = "sm_poc_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sm_assume_role_policy.json
}

data "aws_iam_policy_document" "sm_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "sagemaker_full_access_policy" {
  role       = aws_iam_role.sm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "sagemaker_custom_policy" {
  role       = aws_iam_role.sm_role.name
  policy_arn = aws_iam_policy.sagemaker_custom_policy.arn
}

resource "aws_iam_policy" "sagemaker_custom_policy" {
  name        = "sm_poc_custom_policy"
  description = "Custom policy for SageMaker POC"
  policy      = data.aws_iam_policy_document.sagemaker_custom_policy_document.json
}

data "aws_iam_policy_document" "sagemaker_custom_policy_document" {
  statement {
    sid = "AllowS3Access"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.sm_poc_bucket.arn}/*",
    ]
  }
}