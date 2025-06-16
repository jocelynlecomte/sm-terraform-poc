resource "aws_iam_role" "sm_role" {
  name               = "sm_poc_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sm_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "sm_role_policy" {
  role       = aws_iam_role.sm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
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