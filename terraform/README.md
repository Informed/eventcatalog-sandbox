# Deploy EventCatalog infrastructure

## Terraform Sets up the infrastructure

- Lambda@Edge Function deployment that handles Google Auth access control
- Certificate for the CDN access
- Cloudfront S3 based CDN

## Caveats

- The Lambda needs to be built first in an external repo `cloudfront-auth` based on [Widen/cloudfront-auth](https://github.com/Widen/cloudfront-auth) following the instructions for [Google Hosted Domain authentication method](https://github.com/Widen/cloudfront-auth#google)
  - The resultant build should be put in the `assets` directory
    - Its name should be the `CDN Distribution name` with a `.zip` suffix
    - It should be set in the `main.tf` file in `locals` `lambda_file_name`
  - May eventually pull it in as a submodule here
