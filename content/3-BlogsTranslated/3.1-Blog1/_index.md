---
title: "Blog 1 - GameLift FlexMatch serverless matchmaking"
date: 2026-06-21
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---
{{% notice warning %}}
**Note:** The information below is for reference purposes only. Please **do not copy verbatim** for your report, including this warning.
{{% /notice %}}

# Building matchmaking with Amazon GameLift FlexMatch and serverless services

Facebook source: [AWS Study Group Facebook permalink 2191111528320474](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2191111528320474)

Original AWS blog: [Online Multiplayer with Amazon GameLift and AWS serverless](https://aws.amazon.com/blogs/gametech/online-multiplayer-amazon-gamelift-aws-serverless/)

![Serverless matchmaking architecture](/images/3-blogstranslated/727466501_1798896974424644_7417817182196219607_n.jpg)

## Overview

This post presents a serverless matchmaking backend for online multiplayer games. The architecture uses Amazon Cognito for player identity, Amazon API Gateway as the public backend API, AWS Lambda for backend logic, Amazon DynamoDB for player and matchmaking data, Amazon SNS for events, and Amazon GameLift FlexMatch for matchmaking.

The main goal is to separate real-time gameplay from backend orchestration. Players do not connect directly to matchmaking infrastructure. Instead, they authenticate, call backend APIs, and let AWS services coordinate match tickets and match results.

## Main workflow

1. Players request identity and credentials through Amazon Cognito.
2. The game client calls Amazon API Gateway to access backend APIs.
3. API Gateway invokes AWS Lambda backend functions.
4. Lambda reads and updates player data in DynamoDB.
5. Lambda creates or processes matchmaking tickets in DynamoDB.
6. Amazon GameLift FlexMatch sends matchmaking events to Amazon SNS.
7. Lambda consumes the events and updates the match result for the client.

## Key AWS services

- **Amazon Cognito** manages player identities and authentication.
- **Amazon API Gateway** exposes secure backend endpoints for the game client.
- **AWS Lambda** runs backend logic without requiring a managed server.
- **Amazon DynamoDB** stores player data and matchmaking ticket status.
- **Amazon SNS** receives GameLift FlexMatch events and decouples event processing.
- **Amazon GameLift FlexMatch** handles rule-based matchmaking for multiplayer sessions.

## Why this architecture matters

For RoughLife, this pattern is useful because matchmaking is not part of the UDP gameplay loop. The backend can create, track, and update matchmaking requests while the actual game session is handled separately by GameLift servers. This keeps the gameplay server focused on real-time simulation and keeps account, room, and matchmaking logic in a scalable serverless layer.

## Translated summary

A good multiplayer backend should authenticate players, track player state, create matchmaking tickets, process match results, and return enough information for the client to join the correct session. Using serverless services reduces operational work and makes the matchmaking layer easier to evolve as the game grows.

