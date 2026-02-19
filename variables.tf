variable "aws_region" {
  description = "AWS region for S3 and CloudFront resources"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Global-unique S3 bucket name for portfolio static assets"
  type        = string
  default     = "indraportfolio1"
}

variable "project_name" {
  description = "Tag value used for Name and project tagging"
  type        = string
  default     = "portfolio"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "prod"
}

variable "domain_names" {
  description = "Custom domains for CloudFront (first entry is primary/CN)"
  type        = list(string)
  default     = ["indrakumar.online", "www.indrakumar.online"]
}

variable "custom_domain_enabled" {
  description = "Enable custom domain aliases and ACM certificate on CloudFront"
  type        = bool
  default     = false
}
