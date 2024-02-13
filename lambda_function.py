import boto3
import os
from datetime import datetime

# Fetch KMS Key ID and S3 Bucket Name from Environment Variables
kms_key_id = os.environ.get('KMS_KEY_ID')
bucket_name = os.environ.get('S3_BUCKET_NAME')

s3 = boto3.client('s3')

def lambda_handler(event, context):
    current_timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    object_key = 'timestamp/' + datetime.now().strftime('%Y-%m-%d-%H-%M-%S') + '.txt'
    
    # Upload the timestamp to S3, encrypted with the specified KMS key
    s3.put_object(Body=current_timestamp,
                  Bucket=bucket_name,
                  Key=object_key,
                  ServerSideEncryption='aws:kms',
                  SSEKMSKeyId=kms_key_id)
    
    return {
        'statusCode': 200,
        'body': f'Successfully Uploaded New Object to S3 at: {current_timestamp} '
    }
