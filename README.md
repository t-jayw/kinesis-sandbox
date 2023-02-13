# kinesis-sandbox

Edit the providers.tf file

Spins up:
* Kinesis data stream
* Kinesis firehose and destination s3 bucket
* Lambda function triggered by data stream events
* EC2 w/ (VPC+Subnet+InternetGateway+SecurityGroup+RoutingTables+ElasticIP) + keypair to ssh in
* Necessary IAM stuff

Then run the KinesisProducer.py/KinesisConsumer.py and you have some streaming data to play with
