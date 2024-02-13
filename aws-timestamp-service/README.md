# AWS Timestamp Service

This repository contains the code for a serverless service that uploads a timestamp to an S3 bucket every 10 minutes.
Provides a secure endpoint for retrieving the latest timestamp of an object uploaded in the S3 bucket.

## Repository Structure

- `/terraform/`: Contains the Terraform configuration files for deploying the infrastructure.
- `/terraform/modules/`: Contains reusable Terraform modules for each AWS service.
    - `/lambda/`: Module for AWS Lambda configuration.
    - `/s3/`: Module for S3 bucket configuration.
    - `/kms/`: Module for KMS key configuration.
    - `/api-gateway/`: Module for API Gateway configuration.
    - `/cloudwatch/`: Module for CloudWatch configuration.
- `/src/`: Contains the source code for the Lambda function.
    - `/lambda/upload_timestamp.py`: Python code for the Lambda function that uploads an object with timestamp.

## Deployment Instructions

1. Navigate to the `terraform` directory.
2. Initialize the Terraform environment:

    ```
    terraform init
    ```

3. Plan the Terraform deployment and review the planned actions:

    ```
    terraform plan
    ```

4. Apply the Terraform plan to deploy the infrastructure:

    ```
    terraform apply
    ```

5. To tear down the infrastructure when it's no longer needed:

    ```
    terraform destroy
    ```

## Dependencies

- Terraform
- AWS CLI v2
