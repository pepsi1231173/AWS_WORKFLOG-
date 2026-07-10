---
title: "AWS WAF Web ACL"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5.5. </b> "
---

#### Objective

In this step, the team configures an **AWS WAF Web ACL** to protect the CloudFront Distribution. AWS WAF is used to inspect and control HTTP/HTTPS requests before they reach the protected resource.

For the RoughLife evidence setup, AWS WAF is attached to the CloudFront Distribution that distributes the client build, `version.json`, and `patch_manifest.json`.

#### Implementation Steps

1. Open **AWS WAF & Shield** in the AWS Console.
2. Select **Protection packs (web ACLs)**.
3. Create a new Web ACL for CloudFront.
4. Select the CloudFront Distribution as the protected resource.
5. Enable core protections or AWS Managed Rules.
6. Verify the protection status in the **Security** tab of the CloudFront Distribution.
7. Test the CloudFront URLs again to make sure valid requests are still allowed.

#### AWS WAF Evidence

![WAF CloudFront security](/images/5-Workshop/5.5-Waf-Webacl/04_WAF_CloudFront_Security.png)

The image above shows the Security section of the CloudFront Distribution. Core protections are enabled to protect the CloudFront distribution from common web threats.

![WAF Web ACL](/images/5-Workshop/5.5-Waf-Webacl/04_WAF_WebACL.png)

The image above shows the created Web ACL in AWS WAF. The Web ACL is associated with the CloudFront Distribution and includes basic protection rules.

#### Result

After this step, the CloudFront Distribution has an additional security layer using AWS WAF. This helps protect the HTTP/HTTPS release file delivery layer. It is important to note that AWS WAF protects web traffic only and does not directly protect the UDP gameplay traffic of the game server.