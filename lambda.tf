# Build Lambda Zip

data "archive_file" "lambda_zip" {
  type = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

# Create AWS Lambda

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function.zip"
  function_name = "terraform-kinesis-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  runtime = "python3.8"

  environment {
    variables = {
      DATA_STREAM_NAME = "terraform-kinesis-stream"
    }
  }

  depends_on = [
  ]
}

resource "aws_lambda_function_event_invoke_config" "example" {
  function_name                = aws_lambda_function.test_lambda.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

# Create Lambda Event Source Mapping

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = aws_kinesis_stream.kinesis_stream.arn
  function_name     = aws_lambda_function.test_lambda.arn
  starting_position = "LATEST"

  depends_on = [
    aws_iam_role_policy_attachment.kinesis_processing
  ]
}

