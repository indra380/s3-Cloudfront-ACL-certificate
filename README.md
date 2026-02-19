# Portfolio Infrastructure (Terraform)

This folder contains Terraform code to create portfolio hosting services on AWS.

## Services Created
- S3 bucket for static website files
- CloudFront distribution (CDN)
- CloudFront Origin Access Control (OAC)
- S3 bucket policy that allows only CloudFront access
- ACM certificate in `us-east-1` (for custom domain)
- Security response headers policy on CloudFront

## Prerequisites
- Terraform `>= 1.5`
- AWS account with permission to create S3, CloudFront, and ACM resources
- AWS CLI configured (`aws configure`) or environment credentials exported

## Files You Should Update
1. Copy example variables:
   - `copy terraform.tfvars.example terraform.tfvars`
2. Open `terraform.tfvars` and set:
   - `bucket_name` (must be globally unique)
   - `aws_region` (for S3, default `ap-south-1`)
   - `domain_names` (your domain + optional `www`)
   - `custom_domain_enabled` (`false` for first deployment)

## Steps to Create Services
Run from this folder:

1. Initialize Terraform
   - `terraform init`
2. Validate configuration
   - `terraform validate`
3. Review execution plan
   - `terraform plan`
4. Create infrastructure
   - `terraform apply`

After apply, note these outputs:
- `bucket_name`
- `cloudfront_domain_name`
- `acm_dns_validation_records`

## Custom Domain Setup (Recommended 2-Phase)
Use this order to avoid CloudFront alias/certificate errors.

### Phase 1: Create base infra and certificate request
1. Keep `custom_domain_enabled = false`
2. Run `terraform apply`
3. Copy `acm_dns_validation_records` output

### Phase 2: Validate certificate and enable aliases
1. Add all validation CNAME records in your DNS provider (Spaceship)
2. Wait until ACM certificate status is `ISSUED` in `us-east-1`
3. Set `custom_domain_enabled = true` in `terraform.tfvars`
4. Run `terraform apply` again
5. Create DNS routing records:
   - `www` → CNAME → `cloudfront_domain_name`
   - root/apex (`@`) → ALIAS/ANAME (or CNAME flattening) → `cloudfront_domain_name`

If apex ALIAS is not supported by your DNS provider, redirect root to `www`.

## Deploy Website Files to S3
From project root (after building frontend):
- `npm run build`
- `aws s3 sync dist/ s3://<your-bucket-name> --delete`

Then access your site using CloudFront domain (or your custom domain after DNS propagation).

## Useful Commands
- Show current outputs: `terraform output`
- Re-check plan: `terraform plan`
- Destroy everything: `terraform destroy`

## Notes
- CloudFront deployments can take 10-20 minutes.
- ACM for CloudFront must be in `us-east-1` (already handled in this Terraform code).
- Keep `terraform.tfvars` private if it contains sensitive values.
