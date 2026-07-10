---
title: "Blog 3 - GameLift server fleet with sidecars and state storage"
date: 2026-06-30
weight: 3
chapter: false
pre: " <b> 3.3. </b> "
---
{{% notice warning %}}
**Note:** The information below is for reference purposes only. Please **do not copy verbatim** for your report, including this warning.
{{% /notice %}}

# Designing GameLift server fleets with sidecars and game state storage

Facebook source: [AWS Study Group Facebook permalink 2196945564403737](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2196945564403737)

Original AWS blog: [Faster multiplayer hosting with containers on Amazon GameLift Servers](https://aws.amazon.com/blogs/gametech/faster-multiplayer-hosting-with-containers-on-amazon-gamelift-servers/)

![GameLift fleet with sidecar architecture](/images/3-blogstranslated/731883848_1804734080507600_5742217141909987603_n.jpg)

## Overview

This post introduces an Amazon GameLift Servers fleet architecture where players connect to game sessions running on EC2 instances managed by GameLift. Each game session contains a game server process and a sidecar process. The sidecar can handle supporting tasks such as storing world save files, writing game world data, or communicating with external AWS services.

## Architecture explanation

The fleet contains EC2 instances managed by Amazon GameLift Servers. Each instance can run one or more game sessions. Inside each game session, the game server handles player connections and real-time gameplay, while the sidecar process handles supporting workload outside the main gameplay loop.

The architecture also connects to Amazon S3 and Amazon DynamoDB. S3 can store larger game world save objects, replay files, or server-generated artifacts. DynamoDB can store structured game world data, player progress, session metadata, or lightweight state that needs fast lookup.

## Why use a sidecar

A sidecar process helps keep the game server focused on simulation and networking. Instead of placing every responsibility inside the main server binary, supporting logic can be separated into a companion process. This can make the system easier to test, deploy, and update.

## Key takeaways

- GameLift manages the fleet and game session lifecycle.
- EC2 capacity is abstracted behind the GameLift fleet.
- A game session can include both a game server and sidecar process.
- S3 is suitable for larger files such as world saves or artifacts.
- DynamoDB is suitable for structured state and fast metadata access.

## Application to RoughLife

For RoughLife, this pattern is useful because survival games often need persistent world state, match result records, and player progression. The game server can focus on authoritative gameplay while a sidecar or backend integration handles save and storage tasks. This supports a cleaner separation between real-time gameplay and long-term persistence.

