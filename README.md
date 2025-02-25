### Setup Backend
  ### Setup dynamodb
  aws dynamodb create-table \
           --region ap-southeast-1 \
           --table-name eccomerce-tf-lock \
           --attribute-definitions AttributeName=LockID,AttributeType=S \
           --key-schema AttributeName=LockID,KeyType=HASH \
           --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1    
  ### Setup s3
  aws s3api create-bucket --bucket learning-tf-state --region ap-southeast-1
  
  policy s3
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::{aws_account_id}:user/{nama_user_account}"
              },
              "Action": "s3:*",
              "Resource": "arn:aws:s3:::learning-tf-state"
          }
      ]
  }


### Setup terraform
1. Create access key & secret key
2. COPY .aws_env.example to .aws_env
3. Run `source .aws_env`
4. Go to terraform folder (i.e eccomerce/terraform/providers/aws/eks)
5. RUN terraform init
6. RUN terraform workspace list
7. currently I have 1 workspaces (stg)

 ada beberapa Readme dimasing-masing modul 
 untuk pathnya (terraform/providers/aws/)
