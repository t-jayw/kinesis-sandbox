output "kinesis_stream_name" {
  description = "The Kinesis Data Stream name"
  value       = aws_kinesis_stream.kinesis_stream.name
}


output "eip_public_address" {
  description = "public ip address"
  value = aws_eip.ip-test-env.public_ip
}

output "pem_file_name" {
  description = "ssh private key file"
  value = local_file.myterrakey.filename
}


