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

# Housing Preprocessing Resources
resource "aws_s3_object" "housing_preprocessing_code" {
  bucket = aws_s3_bucket.sm_poc_bucket.bucket
  key    = "/housing/preprocessing/code/preprocess.py"
  source = "../housing/preprocessing/code/preprocess.py"
  etag   = filemd5("../housing/preprocessing/code/preprocess.py")
}

resource "aws_s3_object" "housing_preprocessing_data" {
  bucket = aws_s3_bucket.sm_poc_bucket.bucket
  key    = "/housing/preprocessing/input/input-data.csv"
  source = "../housing/preprocessing/data/raw_data_all.csv"
  etag   = filemd5("../housing/preprocessing/data/raw_data_all.csv")
}

# Housing Training Resources
resource "aws_s3_object" "housing_training_code" {
  bucket = aws_s3_bucket.sm_poc_bucket.bucket
  key    = "/housing/training/code/sourcedir.tar.gz"
  source = "../housing/training/code/sourcedir.tar.gz"
  etag   = filemd5("../housing/training/code/sourcedir.tar.gz")
}