import boto3

def upload_files_to_s3(bucket_name):
    s3 = boto3.client('s3')

    files_to_upload = {
        'dir-1': ['test.json', 'test.txt', 'test.pdf'],
        'dir-2': ['dummy.doc', 'tmp.raw']
    }

    for dir_name, files in files_to_upload.items():
        for file_name in files:
            s3.upload_file(file_name, bucket_name, f"{dir_name}/{file_name}")
            print(f"Uploaded {file_name} to {dir_name}")

if __name__ == "__main__":
    bucket_name = 'nlp-bucket'  # Change this to your actual bucket name if different
    upload_files_to_s3(bucket_name)
