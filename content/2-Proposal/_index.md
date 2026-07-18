---
title: "Proposal"
date: 2026-07-07
weight: 2
chapter: false
pre: " <b> 2. </b> "
---
In this section, you need to summarize the contents of the workshop that you **plan** to conduct.

# RoughLife Online Multiplayer Platform
## AWS GameLift Architecture for Unity NGO + UTP Multiplayer Gameplay

### 1. Executive Summary
RoughLife is an online multiplayer survival game built with Unity Netcode for GameObjects (NGO) and Unity Transport Protocol (UTP). The proposed platform uses AWS services to provide secure player login, room creation, matchmaking, dedicated game server hosting, game session placement, player save data, match result storage, patch delivery, and operational monitoring.

The architecture is designed for a practical internship-scale prototype while still following a production-oriented model. Players download game builds and patches through Amazon CloudFront and Amazon S3, authenticate through Amazon Cognito, create or join rooms through an HTTP API, and receive a GameLift connection response containing the server IP, port, and player session ID. Real-time gameplay traffic then flows directly from the Unity client to the GameLift-hosted server over UDP.

### 2. Problem Statement
### What's the Problem?
A multiplayer game cannot rely only on local hosting or manual server management. The project needs a reliable way to authenticate players, create rooms, match players into sessions, start dedicated server processes, scale game server capacity, store game state, and observe server health. Without a managed architecture, the system becomes difficult to operate, especially when multiple rooms are active at the same time.

### The Solution
The proposed solution uses Amazon GameLift as the dedicated game server layer and combines it with serverless AWS services for the application layer. Amazon API Gateway exposes a Room API, AWS Lambda handles room and matchmaking logic, Amazon Cognito secures login with JWT tokens, and Amazon DynamoDB stores rooms, sessions, player saves, and match results.

Amazon GameLift manages game session placement through a Game Session Queue and Fleet Alias. When a player creates or joins a room, Lambda requests GameLift to create or find a game session. GameLift starts a server process on the managed fleet and returns the connection information to the client. The Unity client then connects to the game server using UDP for gameplay.

### Benefits and Return on Investment
This architecture reduces the amount of custom backend infrastructure required for multiplayer hosting. GameLift handles server lifecycle, placement, and fleet capacity, while the serverless application layer keeps the room and matchmaking workflow simple and cost-efficient for a prototype.

The main value of the project is a reusable AWS multiplayer foundation for RoughLife. It can be used to test core online gameplay, validate dedicated server deployment, study AWS GameLift operations, and prepare a path for future scaling. The architecture also separates responsibilities clearly: CloudFront/S3 for delivery, Cognito for identity, API Gateway/Lambda for orchestration, DynamoDB for state, GameLift for gameplay servers, and CloudWatch/X-Ray/SNS for observability.

### 3. Solution Architecture
The platform is divided into four main layers: global delivery and security, application services, database services, and the GameLift game server layer.

At the edge layer, the Unity client sends HTTPS requests through AWS WAF and Amazon CloudFront. CloudFront serves client builds and patches from an S3 release bucket. In the application layer, Amazon Cognito provides login and JWT authentication. API Gateway exposes the Room API, and Lambda performs create room, join room, matchmaking, and GameLift session operations.

In the database layer, DynamoDB stores room/session data, player save data, and match results. In the game server layer, GameLift uses a Game Session Queue and Managed Fleet Alias to place sessions on available fleet capacity. Each server process can host a game room, report metrics, save final state, and write match results back to DynamoDB.

![RoughLife AWS GameLift Online Multiplayer Architecture](/images/2-Proposal/image.png)

### Main Request Flow
1. The Unity client sends HTTPS requests through AWS WAF and CloudFront.
2. CloudFront downloads game builds and patches from the S3 release bucket.
3. The player logs in through Amazon Cognito and receives a JWT token.
4. The client calls the Room API to create or join a room.
5. API Gateway invokes Lambda for room and matchmaking logic.
6. Lambda reads and writes room/session, player save, and match result data in DynamoDB.
7. Lambda calls GameLift to create or find a game session.
8. GameLift returns the IP address, port, and player session ID to the client.
9. The Unity client connects to the GameLift server by UDP for real-time gameplay.
10. The server saves game state and match results back to DynamoDB.
11. Logs, metrics, traces, and alarms are sent to CloudWatch, X-Ray, and SNS.
12. The developer CI/CD pipeline builds the Unity client/server, uploads client assets to S3, and deploys the dedicated server build to GameLift.

### AWS Services Used
- **AWS WAF**: Protects public HTTPS endpoints from common web attacks and unwanted traffic.
- **Amazon CloudFront**: Distributes game builds, patches, and static assets with low latency.
- **Amazon S3**: Stores release artifacts such as client builds, patches, and assets.
- **Amazon Cognito**: Provides player authentication and JWT-based access control.
- **Amazon API Gateway**: Exposes the HTTP Room API used by the Unity client.
- **AWS Lambda**: Runs room creation, join room, matchmaking, and GameLift orchestration logic.
- **Amazon DynamoDB**: Stores room/session state, player save data, and match results.
- **Amazon GameLift Servers**: Hosts dedicated multiplayer server processes and manages game session placement.
- **Amazon CloudWatch**: Collects logs, metrics, alarms, and server health information.
- **AWS X-Ray**: Traces API Gateway and Lambda requests for debugging.
- **Amazon SNS**: Sends admin alerts when alarms are triggered.

### Component Design
- **Unity Client**: Uses NGO and UTP for multiplayer gameplay. It authenticates, requests matchmaking, receives connection information, and connects to the server over UDP.
- **Authentication Layer**: Cognito validates users and issues JWT tokens used by the Room API.
- **Room API Layer**: API Gateway and Lambda provide create room, join room, and matchmaking endpoints.
- **Data Layer**: DynamoDB keeps the state needed by the application and gameplay flow.
- **Game Server Layer**: GameLift starts Linux dedicated server processes and places game sessions on available fleet capacity.
- **Observability Layer**: CloudWatch, X-Ray, and SNS help monitor errors, latency, server metrics, and operational alerts.
- **CI/CD Layer**: Unity version control and build automation produce client builds, patch assets, and dedicated server artifacts for release.

### 4. Technical Implementation
**Implementation Phases**
- Research and Architecture Design: Study Unity NGO/UTP, dedicated server requirements, GameLift session flow, and AWS service boundaries.
- Cost and Practicality Review: Estimate GameLift fleet usage, data transfer, storage, API calls, and monitoring costs for a small prototype.
- Architecture Adjustment: Refine room creation, matchmaking, save data, deployment, and scaling rules to fit the project scope.
- Development, Testing, and Deployment: Implement the Unity client/server flow, deploy AWS resources, run GameLift integration tests, and verify the full create/join/play/save lifecycle.

**Technical Requirements**
- Unity client using NGO and UTP for gameplay networking.
- Linux dedicated server build compatible with GameLift.
- Cognito user pool for player login and JWT authentication.
- API Gateway HTTP API and Lambda functions for room and matchmaking operations.
- DynamoDB tables for room/session state, player saves, and match results.
- GameLift queue, fleet alias, managed fleet, runtime configuration, and auto scaling policy.
- CloudWatch logs/metrics/alarms, X-Ray tracing, and SNS alerting for operations.
- CI/CD workflow for building the Unity client and server, uploading client releases to S3, and deploying server builds to GameLift.

### 5. Timeline & Milestones
**Project Timeline**
- Month 1: Study AWS GameLift, Unity NGO/UTP, Cognito, API Gateway, Lambda, and DynamoDB. Finalize the architecture and request flow.
- Month 2: Build the Room API, authentication flow, DynamoDB tables, and basic GameLift fleet/session integration.
- Month 3: Integrate the Unity client with matchmaking, UDP gameplay connection, server save flow, monitoring, and CI/CD deployment.
- Post-Launch: Test load behavior, tune scaling rules, improve match placement, and prepare future gameplay features.

### 6. Budget Estimation
The budget depends mainly on GameLift fleet instance hours, data transfer, and the number of active rooms. For an internship prototype, the recommended approach is to keep the fleet small, use minimal test capacity, stop unused resources, and set AWS Budgets alerts.

### Infrastructure Cost Areas
- **GameLift Managed Fleet**: Main cost driver because dedicated server capacity runs on fleet instances.
- **CloudFront and S3**: Used for client build and patch delivery.
- **API Gateway and Lambda**: Low cost for room and matchmaking requests at prototype scale.
- **DynamoDB**: Low cost for room/session, player save, and match result records with small traffic.
- **Cognito**: Low cost for a small number of test users.
- **CloudWatch, X-Ray, and SNS**: Used for logs, traces, metrics, alarms, and admin notifications.

### 7. Risk Assessment
#### Risk Matrix
- GameLift integration complexity: High impact, medium probability.
- Dedicated server build issues: High impact, medium probability.
- UDP networking or firewall problems: High impact, medium probability.
- Cost overrun from running fleet capacity: Medium impact, medium probability.
- Matchmaking or room state inconsistency: Medium impact, medium probability.

#### Mitigation Strategies
- Start with a minimal single-region GameLift fleet and one room flow before adding advanced matchmaking.
- Automate server build packaging and deployment to reduce manual errors.
- Test UDP connectivity early with a simple server process before integrating full gameplay.
- Use AWS Budgets, CloudWatch alarms, and scheduled cleanup for unused resources.
- Keep DynamoDB room/session records explicit and use TTL where appropriate for stale sessions.

#### Contingency Plans
- Use local dedicated server testing if GameLift deployment is blocked.
- Temporarily reduce the architecture to Cognito, API Gateway, Lambda, DynamoDB, and one manually managed test server.
- Roll back to the previous server build alias if a new GameLift build fails.

### 8. Expected Outcomes
#### Technical Improvements
The project delivers a working online multiplayer foundation for RoughLife. Players can log in, create or join rooms, receive GameLift connection details, connect to a dedicated server, play through UDP, and save match results.

#### Long-term Value
The architecture can become the baseline for future RoughLife multiplayer features, including better matchmaking, multi-region placement, party systems, player progression, replay analysis, and production-grade monitoring.

<!--
Old proposal content kept below for reference and hidden from rendered output.

In this section, you need to summarize the contents of the workshop that you **plan** to conduct.

# IoT Weather Platform for Lab Research
## A Unified AWS Serverless Solution for Real-Time Weather Monitoring

### 1. Executive Summary
The IoT Weather Platform is designed for the ITea Lab team in Ho Chi Minh City to enhance weather data collection and analysis. It supports up to 5 weather stations, with potential scalability to 10-15, utilizing Raspberry Pi edge devices with ESP32 sensors to transmit data via MQTT. The platform leverages AWS Serverless services to deliver real-time monitoring, predictive analytics, and cost efficiency, with access restricted to 5 lab members via Amazon Cognito.

### 2. Problem Statement
### What’s the Problem?
Current weather stations require manual data collection, becoming unmanageable with multiple units. There is no centralized system for real-time data or analytics, and third-party platforms are costly and overly complex.

### The Solution
The platform uses AWS IoT Core to ingest MQTT data, AWS Lambda and API Gateway for processing, Amazon S3 for storage (including a data lake), and AWS Glue Crawlers and ETL jobs to extract, transform, and load data from the S3 data lake to another S3 bucket for analysis. AWS Amplify with Next.js provides the web interface, and Amazon Cognito ensures secure access. Similar to Thingsboard and CoreIoT, users can register new devices and manage connections, though this platform operates on a smaller scale and is designed for private use. Key features include real-time dashboards, trend analysis, and low operational costs.

### Benefits and Return on Investment
The solution establishes a foundational resource for lab members to develop a larger IoT platform, serving as a study resource, and provides a data foundation for AI enthusiasts for model training or analysis. It reduces manual reporting for each station via a centralized platform, simplifying management and maintenance, and improves data reliability. Monthly costs are $0.66 USD per the AWS Pricing Calculator, with a 12-month total of $7.92 USD. All IoT equipment costs are covered by the existing weather station setup, eliminating additional development expenses. The break-even period of 6-12 months is achieved through significant time savings from reduced manual work.

### 3. Solution Architecture
The platform employs a serverless AWS architecture to manage data from 5 Raspberry Pi-based stations, scalable to 15. Data is ingested via AWS IoT Core, stored in an S3 data lake, and processed by AWS Glue Crawlers and ETL jobs to transform and load it into another S3 bucket for analysis. Lambda and API Gateway handle additional processing, while Amplify with Next.js hosts the dashboard, secured by Cognito. The architecture is detailed below:

![IoT Weather Station Architecture](/images/2-Proposal/edge_architecture.jpeg)

![IoT Weather Platform Architecture](/images/2-Proposal/platform_architecture.jpeg)

### AWS Services Used
- **AWS IoT Core**: Ingests MQTT data from 5 stations, scalable to 15.
- **AWS Lambda**: Processes data and triggers Glue jobs (two functions).
- **Amazon API Gateway**: Facilitates web app communication.
- **Amazon S3**: Stores raw data in a data lake and processed outputs (two buckets).
- **AWS Glue**: Crawlers catalog data, and ETL jobs transform and load it.
- **AWS Amplify**: Hosts the Next.js web interface.
- **Amazon Cognito**: Secures access for lab users.

### Component Design
- **Edge Devices**: Raspberry Pi collects and filters sensor data, sending it to IoT Core.
- **Data Ingestion**: AWS IoT Core receives MQTT messages from the edge devices.
- **Data Storage**: Raw data is stored in an S3 data lake; processed data is stored in another S3 bucket.
- **Data Processing**: AWS Glue Crawlers catalog the data, and ETL jobs transform it for analysis.
- **Web Interface**: AWS Amplify hosts a Next.js app for real-time dashboards and analytics.
- **User Management**: Amazon Cognito manages user access, allowing up to 5 active accounts.

### 4. Technical Implementation
**Implementation Phases**
This project has two parts—setting up weather edge stations and building the weather platform—each following 4 phases:
- Build Theory and Draw Architecture: Research Raspberry Pi setup with ESP32 sensors and design the AWS serverless architecture (1 month pre-internship)
- Calculate Price and Check Practicality: Use AWS Pricing Calculator to estimate costs and adjust if needed (Month 1).
- Fix Architecture for Cost or Solution Fit: Tweak the design (e.g., optimize Lambda with Next.js) to stay cost-effective and usable (Month 2).
- Develop, Test, and Deploy: Code the Raspberry Pi setup, AWS services with CDK/SDK, and Next.js app, then test and release to production (Months 2-3).

**Technical Requirements**
- Weather Edge Station: Sensors (temperature, humidity, rainfall, wind speed), a microcontroller (ESP32), and a Raspberry Pi as the edge device. Raspberry Pi runs Raspbian, handles Docker for filtering, and sends 1 MB/day per station via MQTT over Wi-Fi.
- Weather Platform: Practical knowledge of AWS Amplify (hosting Next.js), Lambda (minimal use due to Next.js), AWS Glue (ETL), S3 (two buckets), IoT Core (gateway and rules), and Cognito (5 users). Use AWS CDK/SDK to code interactions (e.g., IoT Core rules to S3). Next.js reduces Lambda workload for the fullstack web app.

### 5. Timeline & Milestones
**Project Timeline**
- Pre-Internship (Month 0): 1 month for planning and old station review.
- Internship (Months 1-3): 3 months.
    - Month 1: Study AWS and upgrade hardware.
    - Month 2: Design and adjust architecture.
    - Month 3: Implement, test, and launch.
- Post-Launch: Up to 1 year for research.

### 6. Budget Estimation
You can find the budget estimation on the [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=621f38b12a1ef026842ba2ddfe46ff936ed4ab01).  
Or you can download the [Budget Estimation File](../attachments/budget_estimation.pdf).

### Infrastructure Costs
- AWS Services:
    - AWS Lambda: $0.00/month (1,000 requests, 512 MB storage).
    - S3 Standard: $0.15/month (6 GB, 2,100 requests, 1 GB scanned).
    - Data Transfer: $0.02/month (1 GB inbound, 1 GB outbound).
    - AWS Amplify: $0.35/month (256 MB, 500 ms requests).
    - Amazon API Gateway: $0.01/month (2,000 requests).
    - AWS Glue ETL Jobs: $0.02/month (2 DPUs).
    - AWS Glue Crawlers: $0.07/month (1 crawler).
    - MQTT (IoT Core): $0.08/month (5 devices, 45,000 messages).

Total: $0.7/month, $8.40/12 months

- Hardware: $265 one-time (Raspberry Pi 5 and sensors).

### 7. Risk Assessment
#### Risk Matrix
- Network Outages: Medium impact, medium probability.
- Sensor Failures: High impact, low probability.
- Cost Overruns: Medium impact, low probability.

#### Mitigation Strategies
- Network: Local storage on Raspberry Pi with Docker.
- Sensors: Regular checks and spares.
- Cost: AWS budget alerts and optimization.

#### Contingency Plans
- Revert to manual methods if AWS fails.
- Use CloudFormation for cost-related rollbacks.

### 8. Expected Outcomes
#### Technical Improvements: 
Real-time data and analytics replace manual processes.  
Scalable to 10-15 stations.
#### Long-term Value
1-year data foundation for AI research.  
Reusable for future projects.
-->
