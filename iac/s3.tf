resource "aws_s3_bucket" "sm_poc_bucket" {
  bucket        = "sm-poc-bucket-jle"
  force_destroy = true # Allows terraform destroy to remove the bucket even if it contains objects
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.sm_poc_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}