NGINX Deployment — Multi-Environment Terraform Setup:

This project deploys NGINX infrastructure using Terraform across multiple environments (Dev and QA) with remote state management using AWS S3 and DynamoDB locking.

Prerequisites

Before running Terraform, ensure the following tools and configurations are completed:

1. Install Required Tools
AWS CLI installed and configured
Terraform installed
Git installed

Configure AWS credentials:  aws configure

2. Backend Configuration (One-Time Setup)
Terraform remote state requires an S3 bucket and DynamoDB table.

a) Create S3 Bucket (manual step)

Create an S3 bucket to store Terraform state files.
Use a unique bucket name.

terraform-state-dev
terraform-state-qa


  b) Create DynamoDB Lock Table

This table prevents concurrent Terraform runs.

aws dynamodb create-table \
  --table-name terraform-lock-dev \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1

4. Environment Deployment :
   
Navigate to the respective environment directory before running Terraform.

For Dev enviornment:

1.Move to dev directory  cd environments/dev

Initialize Terraform backend: terraform init -reconfigure 

Plan deployment:terraform plan -var-file="../../tfvars/dev.tfvars"

Apply infrastructure:: terraform apply -var-file="../../tfvars/dev.tfvars"

To destroy :

Destroy Dev Infrastructure terraform destroy -var-file="../../tfvars/dev.tfvars"

For QA enviornment:

1.Move to dev directory  cd environments/qa

Initialize Terraform backend: terraform init -reconfigure 

Plan deployment:terraform plan -var-file="../../tfvars/qa.tfvars"

Apply infrastructure:: terraform apply -var-file="../../tfvars/qa.tfvars"

To destroy :

Destroy Dev Infrastructure terraform destroy -var-file="../../tfvars/qa.tfvars"


Best Practices :

Always initialize Terraform after backend changes

Use environment-specific tfvars files
