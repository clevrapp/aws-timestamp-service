resource "aws_iam_role" "lambda_exec" {
  name = "lambda_execution_role1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:*",
        ],
        Effect = "Allow",
        Resource = [
          "${aws_s3_bucket.bucket.arn}/*",
        ],
      },
      {
        Action = "kms:*",
        Effect = "Allow",
        Resource = [
          aws_kms_key.my_key.arn,
        ],
      },
    ],
  })
}

resource "aws_iam_role" "api_gateway_role" {
  name               = "api_gateway_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_invoke_policy" {
  name = "lambda_invoke_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lambda:*",
      "Resource": "arn:aws:lambda:us-west-1:471112801988:function:upload_timestamp"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_invoke_attachment" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = aws_iam_policy.lambda_invoke_policy.arn
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "CloudWatchLogsPolicy"
  description = "Allows CloudWatch Logs to write logs"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          // Add other permissions as needed
        ],
        Resource  = "*",
      },
    ],
  })
}

resource "aws_iam_role" "api_gateway_cloudwatch_role" {
  name = "api_gateway_cloudwatch_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "api_gateway_cloudwatch_policy" {
  name   = "api_gateway_cloudwatch_policy"
  role   = aws_iam_role.api_gateway_cloudwatch_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
    ]
  })
}


