---
title: "DynamoDB Tables"
date: 2024-01-01
weight: 7
chapter: false
pre: " <b> 5.7. </b> "
---

#### Objective

In this step, the team creates **Amazon DynamoDB** tables to store data for the RoughLife online multiplayer system. DynamoDB is suitable for storing room/session data, player save data, and match result data in a serverless and scalable way.

The created tables include:

- `RoughLifeRooms`: stores room information, room status, player count, and expiration time.
- `RoughLifePlayerSave`: stores player data such as display name, avatar, equipped weapon, unlocked bosses, and owned weapons.
- `RoughLifeMatchResult`: stores match results, boss information, match duration, rewards, and room code.

For the room/session table, **Time to Live (TTL)** is enabled to automatically delete expired room data. This helps reduce stale room records in the database.

#### Implementation Steps

1. Open **Amazon DynamoDB** in the AWS Console.
2. Create the `RoughLifeRooms` table with `roomCode` as the partition key.
3. Create the `RoughLifePlayerSave` table with `playerId` as the partition key.
4. Create the `RoughLifeMatchResult` table with `matchId` as the partition key.
5. Use **On-demand** capacity mode for the tables.
6. Enable TTL for the `RoughLifeRooms` table using the `expiresAt` attribute.
7. Create sample items to demonstrate the expected data structure.

#### DynamoDB Tables Evidence

![DynamoDB tables](/images/5-Workshop/5.7-Dynamodb-tables/06_01.png)

The image above shows the three DynamoDB tables created for the RoughLife system: `RoughLifeRooms`, `RoughLifePlayerSave`, and `RoughLifeMatchResult`. All tables are active and use On-demand capacity mode.

#### TTL Evidence for RoughLifeRooms

![DynamoDB TTL](/images/5-Workshop/5.7-Dynamodb-tables/06_02.png)

The image above shows that Time to Live is enabled for the `RoughLifeRooms` table with the TTL attribute `expiresAt`. This allows expired room/session data to be removed automatically.

#### RoughLifeRooms Item Evidence

![DynamoDB Rooms item](/images/5-Workshop/5.7-Dynamodb-tables/06_03.png)

The image above shows a sample item in the `RoughLifeRooms` table. The item includes fields such as `roomCode`, `createdAt`, `expiresAt`, `gameSessionId`, `hostPlayerId`, `maxPlayers`, `playerCount`, and `roomName`.

#### RoughLifePlayerSave Item Evidence

![DynamoDB PlayerSave item](/images/5-Workshop/5.7-Dynamodb-tables/06_04.png)

The image above shows a sample item in the `RoughLifePlayerSave` table. This table stores player-related data such as `playerId`, `displayName`, equipped weapon, selected avatar, unlocked bosses, and weapon list.

#### RoughLifeMatchResult Item Evidence

![DynamoDB MatchResult item](/images/5-Workshop/5.7-Dynamodb-tables/06_05.png)

The image above shows a sample item in the `RoughLifeMatchResult` table. This table stores match result data such as `matchId`, `bossId`, `durationSeconds`, players, result, rewards, and `roomCode`.

#### Result

After this step, the system has a serverless database layer for storing room/session data, player save data, and match result data. This database layer can be used by Room API, Matchmaking API, or GameLift session logic in future development.