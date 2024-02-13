variable "region" {
  description = "AWS region"
  default     = "us-west-1"
}

variable "bucket_name" {
  description = "S3 bucket name for storing timestamps"
  type        = string
  default     = "my-yahoo-ram"
}

variable "lambda_code_s3_bucket" {
  description = "The S3 bucket where the Lambda function code is stored"
  type        = string
}

variable "lambda_code_s3_key" {
  description = "The S3 key (path) within the bucket to the Lambda function code zip file"
  type        = string
}

