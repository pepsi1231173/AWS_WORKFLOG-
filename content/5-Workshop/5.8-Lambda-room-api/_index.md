---
title: "Lambda Room API"
date: 2024-01-01
weight: 8
chapter: false
pre: " <b> 5.8. </b> "
---

#### Objective

In this step, the team deploys **AWS Lambda** to handle backend logic for the RoughLife online room system. The Lambda function works as a serverless backend layer for room creation, room listing, player save updates, and match result storage.

The Lambda function is named `RoughLifeRoomApi`. It communicates with the DynamoDB tables created in the previous step:

- `RoughLifeRooms`: stores room and session information.
- `RoughLifePlayerSave`: stores player save data.
- `RoughLifeMatchResult`: stores match result data.

In this evidence setup, the Lambda function uses a mock server address and mock server port to simulate server allocation. In a production version, this part can be replaced by Amazon GameLift to allocate real Game Sessions, Player Sessions, IP addresses, and ports.

---

#### Implementation Steps

1. Open **AWS Lambda** in the AWS Console.
2. Create a new function named `RoughLifeRoomApi`.
3. Implement the backend logic for actions such as:
   - `create`: create a new room.
   - `list`: list available rooms.
   - `savePlayer`: save player data.
   - `saveMatchResult`: save match results.
4. Configure Environment Variables for the Lambda function.
5. Attach IAM permissions so the function can read and write DynamoDB data.
6. Test the Lambda function using test events in the AWS Console.
7. Verify that data is written successfully to DynamoDB.

---

#### Lambda Function Evidence

![Lambda overview](/images/5-Workshop/5.8-Lambda-room-api/07_01_Lambda_Overview.png)

The image above shows that the `RoughLifeRoomApi` Lambda function was created successfully. This function acts as the main serverless backend for room, player save, and match result requests.

---

#### Code and Test Event Evidence

![Lambda code test](/images/5-Workshop/5.8-Lambda-room-api/07_02_Lambda_Code_Test.png)

The image above shows the Lambda source code and the test event configuration area. The function receives JSON requests, processes the selected action, and returns a response to the client or API Gateway.

---

#### Environment Variables Evidence

![Lambda environment variables](/images/5-Workshop/5.8-Lambda-room-api/07_03_Lambda_Environment.png)

The image above shows the Environment Variables configured for the Lambda function, including:

- `ROOM_TABLE`: the room/session table name.
- `PLAYER_SAVE_TABLE`: the player save table name.
- `MATCH_RESULT_TABLE`: the match result table name.
- `MAX_PLAYERS`: the maximum number of players per room.
- `ROOM_TTL_SECONDS`: the room expiration time.
- `MOCK_SERVER_ADDRESS`: the mock server address used for evidence.
- `MOCK_SERVER_PORT`: the mock server port used for evidence.

Environment Variables make the function more flexible because table names and server settings can be changed without editing the source code.

---

#### DynamoDB IAM Permission Evidence

![Lambda DynamoDB permission](/images/5-Workshop/5.8-Lambda-room-api/07_04_Lambda_IAM_DynamoDB_Permission.png)

The image above shows that the Lambda IAM Role has been granted permissions to access DynamoDB. These permissions allow the Lambda function to write data into `RoughLifeRooms`, `RoughLifePlayerSave`, and `RoughLifeMatchResult`.

---

#### Create Room Test

![Lambda create room test](/images/5-Workshop/5.8-Lambda-room-api/07_05_Lambda_Test_CreateRoom.png)

The image above shows the Lambda test result for the create room action. The response includes `ok: true`, `roomCode`, `roomName`, `hostName`, `serverAddress`, `serverPort`, `playerCount`, `maxPlayers`, and room member data.

![DynamoDB room created](/images/5-Workshop/5.8-Lambda-room-api/07_06_DynamoDB_Room_Created.png)

The image above shows that the room data was successfully written to the `RoughLifeRooms` table. This proves that Lambda can create a room and store its state in DynamoDB.

---

#### Player Save Test

![Lambda player save API](/images/5-Workshop/5.8-Lambda-room-api/07_07_01_Lambda_PlayerSave_API.png)

The image above shows the Lambda test for saving player data. The response confirms that the player save data was updated successfully.

![DynamoDB player save result](/images/5-Workshop/5.8-Lambda-room-api/07_07_02_DynamoDB_PlayerSave_Result.png)

The image above shows that player data was stored in the `RoughLifePlayerSave` table. The item includes fields such as `playerId`, `displayName`, `lastEquippedWeapon`, `selectedAvatar`, `unlockedBosses`, `playerStats`, and update time.

---

#### Match Result Test

![Lambda match result API](/images/5-Workshop/5.8-Lambda-room-api/07_08_01_Lambda_MatchResult_API.png)

The image above shows the Lambda test for saving match result data. The response confirms that the match result was saved successfully.

![DynamoDB match result](/images/5-Workshop/5.8-Lambda-room-api/07_08_02_DynamoDB_MatchResult_Result.png)

The image above shows that match result data was written into the `RoughLifeMatchResult` table. The data includes `matchId`, `roomCode`, `bossId`, `result`, `durationSeconds`, players, and rewards.

---

#### Result

After this step, the team successfully deployed the Lambda backend for the RoughLife online room system. The function can process room creation, room listing, player save updates, and match result storage. It is also connected to DynamoDB through an IAM Role and can write data to the required tables.

This is an important step in moving the lobby and room system from local testing to a serverless backend architecture on AWS.