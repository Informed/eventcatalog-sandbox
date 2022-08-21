output "s3_bucket" {
  description = "Name of the S3 origin bucket"
  value       = module.cloudfront-s3-cdn.s3_bucket
}

output "cf_aliases" {
  description = "Aliases of the CloudFront distribution"
  value       = module.cloudfront-s3-cdn.aliases
}

output "cf_domain_name" {
  description = "Domain name corresponding to the distribution"
  value       = module.cloudfront-s3-cdn.cf_domain_name
}
