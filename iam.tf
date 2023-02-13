# IAM Role Creation

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM Policy Creation: Allow Cloudwatch Logging

resource "aws_iam_policy" "allow_logging" {
  name        = "allow_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# IAM Policy Creation: Allow Kinesis Processing

resource "aws_iam_policy" "allow_kinesis_processing" {
  name        = "allow_kinesis_processing"
  path        = "/"
  description = ""

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kinesis:ListShards",
        "kinesis:ListStreams",
        "kinesis:*"
      ],
      "Resource": "arn:aws:kinesis:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "stream:GetRecord",
        "stream:GetShardIterator",
        "stream:DescribeStream",
        "stream:*"
      ],
      "Resource": "arn:aws:stream:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach IAM Policies to Roles

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow_logging.arn
}

resource "aws_iam_role_policy_attachment" "kinesis_processing" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow_kinesis_processing.arn
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement":
  [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  inline_policy {
    name = "kinesis-s3-inline-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {      
          Effect = "Allow",      
          Action = [
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
          ]      
          Resource = [        
            "arn:aws:s3:::tjw-kinesis-demo-test-bucket",
            "arn:aws:s3:::tjw-kinesis-demo-test-bucket/*"            
          ]    
        },
        {
          Effect = "Allow"
          Action = [
            "kinesis:DescribeStream",
            "kinesis:GetShardIterator",
            "kinesis:GetRecords",
            "kinesis:ListShards"
          ]
          Resource = [
            "arn:aws:kinesis:*" 
          ]
        }
      ]
    })
  }
}
