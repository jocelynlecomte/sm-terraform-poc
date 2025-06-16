output "sagemaker_domain_id" {
  value = aws_sagemaker_domain.sm_poc_domain.id
}

output "sagemaker_user_profile" {
  value = aws_sagemaker_user_profile.sm_poc_user_profile.user_profile_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.sm_poc_bucket.bucket
}