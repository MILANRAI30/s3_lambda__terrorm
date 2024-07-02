1. Create the Directory for Terraform Configuration

# mkdir terraform-s3-lambda
# cd terraform-s3-lambda

2. Create a lambda function and zip the file

# zip lambda_function.zip lambda_function.py

3. Create the Directory Structure and Files for Upload

# mkdir -p files/dir-1 files/dir-2
# touch files/dir-1/test.json files/dir-1/test.txt files/dir-1/test.pdf
# touch files/dir-2/dummy.doc files/dir-2/tmp.raw

4. Write and Apply the Terraform Configuration

# terraform init
# terraform apply

5. Upload Files to S3

# python upload_files.py

6. Invoke the Lambda Function

# aws lambda invoke --list_files_lambda list_files_lambda output.json

