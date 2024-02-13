resource "aws_cloudwatch_event_rule" "every_10_minutes" {
  name                = "every-10-minutes-rule"
  description         = "Trigger every 10 minutes"
  schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.every_10_minutes.name
  target_id = "InvokeLambdaFunction"
  arn       = aws_lambda_function.upload_timestamp.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_timestamp.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_10_minutes.arn
}

# Example CloudWatch alarm for monitoring
resource "aws_cloudwatch_metric_alarm" "high_error_rate" {
  alarm_name          = "high_error_rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors api gateway 5XX errors"
  dimensions = {
    ApiName = aws_api_gateway_rest_api.api.name
  }
}
