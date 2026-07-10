---
title: "AWS X-Ray Trace Setup"
date: 2024-01-01
weight: 14
chapter: false
pre: " <b> 5.14. </b> "
---

#### Objective

In this step, the team enables **AWS X-Ray** for the `RoughLifeRoomApi` Lambda function to prepare tracing capability for the RoughLife serverless backend.

AWS X-Ray helps trace request processing across backend services. When the Unity Client calls API Gateway and API Gateway invokes Lambda, X-Ray can record trace data so the team can analyze processing time, errors, and bottlenecks in the backend request flow.

In the RoughLife architecture, X-Ray is part of the observability layer together with CloudWatch Logs, CloudWatch Metrics, and SNS Alert.

---

#### Implementation Steps

1. Open **AWS Lambda** in the AWS Console.
2. Select the `RoughLifeRoomApi` function.
3. Open the **Configuration** tab.
4. Select **Monitoring and operations tools**.
5. Enable **Active tracing** for AWS X-Ray.
6. Save the configuration.
7. Invoke Lambda or call API Gateway to generate new requests.
8. Check monitoring and tracing data after requests are recorded.

---

#### Lambda X-Ray Evidence

![Lambda X-Ray Enabled](/images/5-Workshop/5.14-xray-trace/13_01_Lambda_XRay_Enabled.png)

The image above shows that AWS X-Ray was enabled for the `RoughLifeRoomApi` Lambda function. After active tracing is enabled, Lambda can send trace data to X-Ray during request processing.

---

#### Role of X-Ray in the RoughLife System

In the RoughLife online multiplayer system, X-Ray helps the team observe the serverless backend more clearly.

X-Ray can help analyze:

- Requests from API Gateway to Lambda.
- Lambda request processing time.
- Errors during Room API execution.
- DynamoDB read/write operations when tracing is integrated properly.
- Backend latency when players create rooms or list available rooms.

With X-Ray, the team can identify whether a slow request is caused by API Gateway, Lambda, or the database layer. This makes backend debugging and optimization easier as the system grows.

---

#### Planned Tracing Flow

The planned tracing flow for the RoughLife backend is:

1. Unity Client sends a request to API Gateway.
2. API Gateway forwards the request to the `RoughLifeRoomApi` Lambda function.
3. Lambda processes actions such as room creation, room listing, or data saving.
4. Lambda reads or writes data to DynamoDB.
5. X-Ray records trace data so the team can observe the request flow.

At the current evidence stage, the team enabled Active tracing for Lambda. As the system expands, X-Ray can be used together with API Gateway, Lambda, and DynamoDB to observe the full backend request path.

---

#### Result

After this step, AWS X-Ray Active tracing was enabled for the `RoughLifeRoomApi` Lambda function. This is an important preparation step for the backend observability layer.

When more requests are generated from the Unity Client or API Gateway, X-Ray will help the team trace, analyze, and optimize the Room API processing flow. This improves the monitoring capability of the RoughLife online multiplayer deployment on AWS.