resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  // Additional configurations for your S3 bucket (e.g., versioning, logging) can go here.
}

resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.bucket.id  // Ensure this uses the correct bucket ID
  key    = var.lambda_code_s3_key   // The key for the Lambda function code in the S3 bucket
  source = "lambda_function.zip"    // Path to the Lambda zip file in your local environment
  etag   = filemd5("lambda_function.zip") // Use etag for updates based on the zip file's MD5 hash
}

resource "aws_lambda_function" "upload_timestamp" {
  function_name = "upload_timestamp"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec.arn

  s3_bucket     = aws_s3_bucket.bucket.bucket  // Use the bucket name instead of ID
  s3_key        = aws_s3_object.lambda_code.key  // Corrected to use aws_s3_object

  source_code_hash = filebase64sha256("lambda_function.zip") // Ensures updates on code change

  environment {
    variables = {
      KMS_KEY_ID      = aws_kms_key.my_key.id
      S3_BUCKET_NAME  = aws_s3_bucket.bucket.bucket // Passes the bucket name to the Lambda environment
    }
  }

  depends_on = [aws_s3_object.lambda_code] // Corrected dependency reference
}
