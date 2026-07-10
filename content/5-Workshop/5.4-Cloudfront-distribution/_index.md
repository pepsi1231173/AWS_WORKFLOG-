---
title: "CloudFront Distribution"
date: 2024-01-01
weight: 4
chapter: false
pre: " <b> 5.4. </b> "
---

#### Objective

In this step, the team creates an **Amazon CloudFront Distribution** to distribute RoughLife release files from the S3 bucket through HTTPS. CloudFront allows players or the game client to access files such as `version.json`, `patch_manifest.json`, and `RoughLife_Client_Window.zip` using a CloudFront domain instead of directly accessing the S3 bucket.

The CloudFront Distribution uses the S3 bucket as its origin. Origin Access Control is configured so CloudFront can securely read files from the private S3 bucket.

#### Implementation Steps

1. Open **Amazon CloudFront** in the AWS Console.
2. Select **Create distribution**.
3. In **Origin domain**, choose the S3 release bucket created in the previous step.
4. Configure the origin access using **Origin Access Control**.
5. In the default cache behavior:
   - Allow `GET` and `HEAD` methods.
   - Redirect HTTP requests to HTTPS.
   - Use a cache policy suitable for static content.
6. Set the **Default root object** to `version.json`.
7. Create the distribution and wait until the status becomes **Deployed**.
8. Test the CloudFront URLs:
   - `/version.json`
   - `/patch_manifest.json`
   - `/builds/windows/RoughLife_Client_Window.zip`

#### CloudFront Distribution Evidence

![CloudFront distribution](/images/5-Workshop/5.4-Cloudfront-distribution/03_CloudFront_Distribution.png)

The image above shows that the CloudFront Distribution was created successfully using the Free plan. The distribution provides a CloudFront domain for accessing the release files through HTTPS.

![CloudFront origin](/images/5-Workshop/5.4-Cloudfront-distribution/03_CloudFront_Origin.png)

The image above shows that the CloudFront origin is connected to the RoughLife S3 release bucket. The origin type is S3 and the origin access configuration is enabled.

![CloudFront check URL](/images/5-Workshop/5.4-Cloudfront-distribution/03_CheckURL.png)

The image above shows successful testing of the CloudFront URLs. The `version.json` and `patch_manifest.json` files can be opened in the browser, and the `RoughLife_Client_Window.zip` file can be downloaded successfully.

#### Result

After this step, the system has an HTTPS endpoint through CloudFront for distributing the game client build and update metadata files. This provides evidence for the client build and patch distribution layer of the RoughLife online system.