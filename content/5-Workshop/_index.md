---
title: "Workshop"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# AWS Evidence Setup for RoughLife Online Multiplayer System

#### Overview

In this workshop, the RoughLife team configures several AWS services as evidence for the online multiplayer game architecture. The purpose of this section is to demonstrate how the system can distribute the game client build, protect HTTP/HTTPS traffic, prepare player authentication, and store online gameplay data such as rooms, player saves, and match results.

The AWS services used in this evidence setup include:

- **AWS Budgets** for cost monitoring and budget alerts.
- **Amazon S3** for storing the client build, version file, and patch manifest.
- **Amazon CloudFront** for distributing the client build and patch files through HTTPS.
- **AWS WAF** for protecting CloudFront from invalid or suspicious web requests.
- **Amazon Cognito** for preparing player authentication.
- **Amazon DynamoDB** for storing room/session data, player save data, and match result data.

#### Contents

1. [Workshop Overview](5.1-workshop-overview/)
2. [Budget](5.2-budget/)
3. [S3 Release Bucket](5.3-s3-release-bucket/)
4. [Cloudfront Distribution](5.4-cloudfront-distribution/)
5. [Waf-Webacl](5.5-waf-webacl/)
6. [Cognito userpool](5.6-cognito-userpool/)
7. [DynamoDB Tables](5.7-dynamodb-tables/)
8. [Lambda Room API](5.8-lambda-room-api/)
9. [API Gateway HTTP API](5.9-api-gateway/)
10. [Amazon GameLift Build and Fleet Setup](5.10-gamelift-build-fleet/)
11. [GameLift Alias and Game Session Queue Setup](5.11-gamelift-queue-alias/)
12. [CloudWatch Logs and Alarm Configuration](5.12-cloudWatch-logs,monitor,alarm/)
13. [SNS Admin Alert Setup](5.13-sns-admin-alert/)
14. [AWS X-Ray Trace Setup](5.14-xray-trace/)
15. [AWS Resources Cleanup](5.15-cleanup/)