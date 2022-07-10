##
## Create the S3 bucket with CloudFront distribution necessary to host the site
##

module "cloudfront-s3-cdn" {
  source  = "cloudposse/cloudfront-s3-cdn/aws"
  version = "0.82.4"

  namespace               = var.bucket_namespace
  environment             = var.environment
  stage                   = var.project_name
  name                    = var.app_name
  encryption_enabled      = true
  allow_ssl_requests_only = false
  # This will allow a complete deletion of the bucket and all of its contents
  origin_force_destroy = true

  # DNS Settings
  parent_zone_id      = var.zone_id
  acm_certificate_arn = module.acm_request_certificate.arn
  aliases             = concat([local.fqdn], local.alt_fqdns)
  ipv6_enabled        = true
  dns_alias_enabled   = true

  # Caching Settings
  default_ttl = 300
  compress    = true

  # Website settings
  website_enabled = true
  index_document  = "index.html"
  error_document  = "404.html"

  depends_on = [module.acm_request_certificate]

  # Link Lambda@Edge to the CloudFront distribution
  lambda_function_association = [{
    event_type   = "viewer-request"
    include_body = false
    lambda_arn   = aws_lambda_function.edge.qualified_arn
  }]
}


###
### Request an SSL certificate
###
module "acm_request_certificate" {
  source                            = "cloudposse/acm-request-certificate/aws"
  version                           = "0.16.0"
  domain_name                       = local.fqdn
  subject_alternative_names         = local.alt_fqdns
  process_domain_validation_options = true
  ttl                               = "300"
  wait_for_certificate_issued       = true
  zone_name                         = local.zone_name
}
