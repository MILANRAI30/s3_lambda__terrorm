provider "aws" {
  region = "us-west-2"  # Change the region as per your requirement
}

# Create S3 Bucket
resource "aws_s3_bucket" "nlp_bucket" {
  bucket = "nlp-bucket"

  versioning {
    enabled = true
  }

}

# Create folders in the S3 Bucket
resource "aws_s3_bucket_object" "dir1" {
  bucket = aws_s3_bucket.nlp_bucket.bucket
  key    = "dir-1/"
}

resource "aws_s3_bucket_object" "dir2" {
  bucket = aws_s3_bucket.nlp_bucket.bucket
  key    = "dir-2/"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_s3_exec_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }]
  })
}

# IAM Policy for Lambda to access S3
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_s3_policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.nlp_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.nlp_bucket.bucket}/*"
        ]
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "list_files_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "list_files_lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.9"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.nlp_bucket.bucket
    }
  }
}

# Lambda Permission to be invoked by S3
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_files_lambda.function_name
  principal     = "s3.amazonaws.com"
}
