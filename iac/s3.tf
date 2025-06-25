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

################ Housing Pipeline Resources ################
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

# Housing Model Evaluation Resources
resource "aws_s3_object" "housing_evaluating_data" {
  bucket = aws_s3_bucket.sm_poc_bucket.bucket
  key    = "/housing/evaluating/code/evaluate.py"
  source = "../housing/evaluating/code/evaluate.py"
  etag   = filemd5("../housing/evaluating/code/evaluate.py")
}
################ Housing Pipeline Resources ################

################ Abalone Pipeline Resources ################
# Abalone Preprocessing Resources
resource "aws_s3_object" "abalone_preprocessing_code" {
  bucket = aws_s3_bucket.sm_poc_bucket.bucket
  key    = "/abalone/preprocessing/code/preprocessing.py"
  source = "../abalone/preprocessing/code/preprocessing.py"
  etag = filemd5("../abalone/preprocessing/code/preprocessing.py")
}

resource "aws_s3_object" "abalone_preprocessing_data" {
  bucket = aws_s3_bucket.sm_poc_bucket.bucket
  key    = "/abalone/preprocessing/input/input-data.csv"
  source = "../abalone/preprocessing/data/abalone-dataset.csv"
  etag   = filemd5("../abalone/preprocessing/data/abalone-dataset.csv")
}

# Abalone Model Evaluation Resources
resource "aws_s3_object" "abalone_evaluating_data" {
  bucket = aws_s3_bucket.sm_poc_bucket.bucket
  key    = "/abalone/evaluation/code/evaluation.py"
  source = "../abalone/evaluation/code/evaluation.py"
  etag   = filemd5("../abalone/evaluation/code/evaluation.py")
}

# Abalone Transform Resources
resource "aws_s3_object" "abalone_batch_data" {
  bucket = aws_s3_bucket.sm_poc_bucket.bucket
  key    = "/abalone/transform/input/input-data.csv"
  source = "../abalone/transform/data/abalone-dataset-batch.csv"
  etag   = filemd5("../abalone/transform/data/abalone-dataset-batch.csv")
}