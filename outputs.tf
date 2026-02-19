output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.portfolio.id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.portfolio.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name for website access"
  value       = aws_cloudfront_distribution.portfolio.domain_name
}

output "custom_domain_enabled" {
  description = "Whether CloudFront custom domain aliases are enabled"
  value       = var.custom_domain_enabled
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN in us-east-1"
  value       = aws_acm_certificate.portfolio.arn
}

output "acm_dns_validation_records" {
  description = "DNS CNAME records to add in Spaceship for ACM validation"
  value = [
    for dvo in aws_acm_certificate.portfolio.domain_validation_options : {
      domain_name  = dvo.domain_name
      record_name  = dvo.resource_record_name
      record_type  = dvo.resource_record_type
      record_value = dvo.resource_record_value
    }
  ]
}
