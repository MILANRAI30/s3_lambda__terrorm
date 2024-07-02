import json
import boto3

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket_name = event['bucket_name']
    
    # List all objects in the S3 bucket
    response = s3.list_objects_v2(Bucket=bucket_name)
    files = response.get('Contents', [])
    
    file_extensions = {}
    
    for file in files:
        key = file['Key']
        extension = key.split('.')[-1]
        if extension in file_extensions:
            file_extensions[extension] += 1
        else:
            file_extensions[extension] = 1
    
    return {
        'statusCode': 200,
        'body': json.dumps(file_extensions)
    }
