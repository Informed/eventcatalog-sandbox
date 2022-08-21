# EventCatalog Sandbox with Terraform Deployment to Cloudfront

Project so show how to deploy your own EventCatalog in [AWS CloudFront](https://aws.amazon.com/cloudfront/) via [Terraform](https://www.terraform.io) and updates to the Catalog via CI/CD ([CircleCi](http://www.circleci.com) in this case, but can be easily applied to other CI systems). It also shows how to use [Lambda@Edge](https://aws.amazon.com/lambda/edge/) to implement [Google SSO  / OpenID Connect](https://developers.google.com/identity/protocols/oauth2/openid-connect) via the [Widen/cloudfront-auth](https://github.com/Widen/cloudfront-auth) Project.

This project uses the demo scaffolding from  [EventCatalog](https://www.eventcatalog.dev) for the content and for building the static assets to deploy to Cloudfront.

[David Boyne](https://www.boyney.io)'s [EventCatalog](https://www.eventcatalog.dev) is an wonderful Open Source project that acts as a unifying Documentation tool for Event-Driven Architectures. It helps you document, visualize and keep on top of your Event Driven Architectures' events, schemas, producers, consumers and services.

The main value add is in the `terraform` directory which builds Cloudfront and lambda@edge infrastructure. The  `.circleci/config.yml` deploys the content to Cloudfront's S3 bucket.

A full description of how to use it is in [Deploy EventCatalog with Google SSO Access Control via AWS CloudFront](doc/deploy-eventcatalog-with-cloudfront-and-sso.md)

## TL:DR

### Assumptions and Prerequisites

* Have rights to creating infrastructure in an AWS Account
* You have the AWS CLI installed and can use it from your shell window with IAM permissions for your account
* You have a Circleci account connected to the Github repo you forked
* Node.js version >= 14 or above (which can be checked by running node -v). You can use nvm for managing multiple Node versions on a single machine installed
* Yarn version >= 1.5 (which can be checked by running yarn --version). Yarn is a performant package manager for JavaScript and replaces the npm client. It is not strictly necessary but highly encouraged.

### Get things going
* Fork this repo into your own Github account
* git clone your fork to your local dev computer
* cd eventcatalog-sandbox/terraform
* Edit sandbox.tfvars or create your own tfvars file with changes appropriate for your environment
  * Don't use any of the existing values except `region` (You may have to keep region to `us-east-1`)
  * Set `lambda_file_name = assets/temp.zip`
* Run terraform
    ``` shell
    terraform init
    terraform apply  -var-file=sandbox.tfvars
    ```
* The output of the terraform run will show the
  * s3_bucket name
  * the Cloudfront distribution name as `cf_domain_name`

### Generate Lambda@Edge authentication code
* You might as well read the [full doc on this](doc/deploy-eventcatalog-with-cloudfront-and-sso.md#build-the-lambdaedge-code-with-widencloudfront-auth) as this is one of the more complicated steps.

An oversimplified set of steps:

* Need to clone a copy of the [Widen/cloudfront-auth](https://github.com/Widen/cloudfront-auth) Project
in some other directory outside of the cloned repo
* Follow the instructions there and run the `build.sh` there to generate the lambda zip file
* Copy the zip file created by these steps to the `eventcatalog-sandbox/terraform/assets` folder

### Deploy the new zip file to the lambda@edge and update the Cloudfront distribution
* Go back to `eventcatalog-sandbox/terraform`
* Run terraform again
    ``` shell
    terraform apply  -var-file=sandbox.tfvars
    ```
* The output of the terraform run will show the
  * s3_bucket name
  * Aliases of the hostnames to access the site with
  
### Update the CircleCi config to use the proper s3 bucket
* Edit `eventcatalog-sandbox/.circleci/config.yml` to set the s3 bucket it will upload to to be the same one as was created by the terraform run.
* Git push and have the CircleCi run build and deploy the content from eventcatalog-sandbox to the Cloudfront distribution

### Try it out
* Use the browser to access the site using one of the aliases from the output of the terraform run 
