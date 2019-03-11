 # Technologies used
    * AWS
        - ECS
        - ALB
        - ECR
        - VPC 
        - IAM
        - CloudWatch
        - CloudFront 
        - RDS 
        - Autoscaling (performance based as well as schedule based)
    * Terraform (0.11.8)
    * Official WordPress docker image


# Process to setup multi-regions HA wordpress
    * Execute the terraform script on two different regions (us-west-1 and ap-northeast-1)
    * Configure cloudfront (not part of this script yet) to serve static files in multi-regions.
    * Configure Active-Active database replication on the RDS.
    * Configure Route53 to server web requests based on geo location.

# Todo in the scripts
    * Configure cloudfront to serve static files in multi-regions.
    * Configure Active-Active database replication on the RDS.
    * Configure Route53 to server web requests based on geo location.
    * Create an ansible wrapper to run the script multiple times on confgured multiple zones.
    * Terraform backend (terraform state) as S3 Bucket.

