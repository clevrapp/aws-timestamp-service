resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/api_gateway/TimestampAPI"
  retention_in_days = 90
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "TimestampAPI"
  description = "API to fetch the latest timestamp"
}

resource "aws_api_gateway_resource" "timestamp_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "timestamp"
}

resource "aws_api_gateway_method" "timestamp_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.timestamp_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.timestamp_resource.id
  http_method             = aws_api_gateway_method.timestamp_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.upload_timestamp.arn}/invocations"
}


resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id

  # This deployment now directly sets the stage name to 'v1', making the stage immediately usable.
  stage_name = "v1"

  triggers = {
    redeployment = sha256(jsonencode({
      method = aws_api_gateway_method.timestamp_get.http_method,
      uri    = aws_api_gateway_integration.lambda_integration.uri
    }))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_timestamp.function_name
  principal     = "apigateway.amazonaws.com"
  // Optionally, restrict to a specific source ARN
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}


output "api_invoke_url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com/v1/timestamp"
}