# Create Kinesis Data Stream

resource "aws_kinesis_stream" "kinesis_stream" {
  name             = "terraform-kin-stream"
  shard_count      = 1
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "IncomingRecords",
    "OutgoingBytes",
    "OutgoingRecords",
  ]

  tags = {
    CreatedBy = "terraform-kinesis-lambda"
  }
}

