resource "aws_sagemaker_domain" "sm_poc_domain" {
  domain_name = "sm-poc-domain"
  auth_mode   = "IAM"
  vpc_id      = aws_default_vpc.sm_poc_vpc.id
  subnet_ids  = [aws_default_subnet.sm_poc_subnet.id]

  default_user_settings {
    execution_role = aws_iam_role.sm_role.arn
  }
}

resource "aws_sagemaker_user_profile" "sm_poc_user_profile" {
  domain_id         = aws_sagemaker_domain.sm_poc_domain.id
  user_profile_name = "sm-poc-user-profile"

  user_settings {
    execution_role = aws_iam_role.sm_role.arn
  }
}