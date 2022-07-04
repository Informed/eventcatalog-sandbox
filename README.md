# EventCatalog Sandbox with Terraform Deployment to Cloudfront

Project so show how to deploy your own EventCatalog in [AWS CloudFront](https://aws.amazon.com/cloudfront/) via [Terraform](https://www.terraform.io) and updates to the Catalog via CI/CD ([CircleCi](http://www.circleci.com) in this case, but can be easily applied to other CI systems). It also shows how to use [Lambda@Edge](https://aws.amazon.com/lambda/edge/) to implement [Google SSO  / OpenID Connect](https://developers.google.com/identity/protocols/oauth2/openid-connect) via the [Widen/cloudfront-auth](https://github.com/Widen/cloudfront-auth) Project.

This project uses the demo scaffolding from  [EventCatalog](https://www.eventcatalog.dev) for the content and for building the static assets to deploy to Cloudfront.

[David Boyne](https://www.boyney.io)'s [EventCatalog](https://www.eventcatalog.dev) is an wonderful Open Source project that acts as a unifying Documentation tool for Event-Driven Architectures. It helps you document, visualize and keep on top of your Event Driven Architectures' events, schemas, producers, consumers and services.

The main value add is in the `terreform` directory which builds Cloudfront and lambda@edge infrastructure. The  `.circleci/config.yml` deploys the content to Cloudfront's S3 bucket.

A full description of how to use it is in [Deploy EventCatalog with Google SSO Access Control via AWS CloudFront](doc/deploy-eventcatalog-with-cloudfront-and-sso.md)
