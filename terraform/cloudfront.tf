/** Create the S3 bucket with CloudFront distribution necessary to host the site */
module "cloudfront-s3-cdn" {
  source  = "cloudposse/cloudfront-s3-cdn/aws"
  version = "0.82.4"

  name                    = "eventcatalog"
  environment             = "rob"
  namespace               = "infomred-iq"
  encryption_enabled      = true
  allow_ssl_requests_only = false

  # DNS Settings
  parent_zone_id      = var.zone_id
  acm_certificate_arn = module.acm_request_certificate.arn
  aliases             = [var.fqdn, var.alt_fqdn]
  ipv6_enabled        = true
  dns_alias_enabled   = true

  # Caching Settings
  default_ttl = 300
  compress    = true

  # Website settings
  website_enabled = true
  index_document  = "index.html"
  error_document  = "404.html"
  # deployment_principal_arns = {
  #   "arn:aws:iam::170256646665:role/informed-principal-engineer" = [""]
  # }

  depends_on = [module.acm_request_certificate]

  # Lambda@Edge setup
  lambda_function_association = [{
    event_type   = "viewer-request"
    include_body = false
    lambda_arn   = aws_lambda_function.eventcatalog_auth_lambda.qualified_arn
  }]
}


# /** Request an SSL certificate */
module "acm_request_certificate" {
  source                            = "cloudposse/acm-request-certificate/aws"
  version                           = "0.16.0"
  domain_name                       = var.fqdn
  subject_alternative_names         = [var.alt_fqdn]
  process_domain_validation_options = true
  ttl                               = "300"
  wait_for_certificate_issued       = true
  zone_name                         = var.zone_name
}
