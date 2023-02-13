import boto3

def process_records(Records):
    #---------------------------
    # Your processing goes here
    #---------------------------
    print(Records)


def main():
    stream_name = 'terraform-kin-stream'
    
    try:
        session = boto3.Session(profile_name='tylerw')
        kinesis_client = session.client('kinesis')

        #------------------
        # Get the shard ID.
        #------------------
        response = kinesis_client.describe_stream(StreamName=stream_name)
        shard_id = response['StreamDescription']['Shards'][0]['ShardId']

        #---------------------------------------------------------------------------------------------
        # Get the shard iterator.
        #---------------------------------------------------------------------------------------------
        response = kinesis_client.get_shard_iterator(
            StreamName=stream_name,
            ShardId=shard_id,
            ShardIteratorType='LATEST'
        )
        shard_iterator = response['ShardIterator']

        #-----------------------------------------------------------------
        # Get the records.
        # Get max_records from the shard, or run continuously if you wish.
        #-----------------------------------------------------------------
        max_records = 100
        record_count = 0

        while record_count < max_records:
            response = kinesis_client.get_records(
                ShardIterator=shard_iterator,
                Limit=10
            )
            shard_iterator = response['NextShardIterator']
            records = response['Records']
            record_count += len(records)
            process_records(records)

    except ClientError as e:
        logger.exception("Couldn't get records from stream %s.", stream_name)
        raise


if __name__ == "__main__":
    while True:
        main()
