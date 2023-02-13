
import datetime
import json
import random
import boto3
import time

STREAM_NAME = "terraform-kin-stream"
"terraform-kin-stream"

def get_data():
	return {
		'event_time': datetime.datetime.now().isoformat(),
		'ticker': random.choice(['AAPL', 'AMZN', 'MSFT', 'INTC', 'TBV']),
		'price': round(random.random() * 100, 2)}


def generate(stream_name, kinesis_client):
	while True:
		time.sleep(1)
		data = get_data()
		print(data)
		kinesis_client.put_record(
			StreamName=stream_name,
			Data=json.dumps(data),
			PartitionKey="partitionkey")


if __name__ == '__main__':
        session = boto3.Session(profile_name='tylerw')
        generate("terraform-kin-stream", 
             session.client('kinesis', region_name='us-east-1'))
