---
title: "API Gateway HTTP API"
date: 2024-01-01
weight: 9
chapter: false
pre: " <b> 5.9. </b> "
---

#### Objective

In this step, the team deploys **Amazon API Gateway** to expose the `RoughLifeRoomApi` Lambda function through an HTTP endpoint. API Gateway acts as the communication gateway between the Unity Client and the Lambda backend.

Instead of calling Lambda directly, the Unity Client sends HTTP requests to API Gateway. API Gateway then forwards those requests to Lambda for processing room creation, room listing, player save updates, and match result storage.

#### Overall Processing Flow

The Room API processing flow is designed as follows:

1. **Unity Client** sends an HTTP request to API Gateway.
2. **API Gateway HTTP API** receives the request through the `/room` route.
3. **Lambda RoughLifeRoomApi** processes the action from the request body.
4. **DynamoDB** stores or returns the related data.

This flow separates the Unity Client from direct Lambda invocation and provides a clear HTTP endpoint for the game client to use during room creation, room listing, and online data storage.

---

#### Implementation Steps

1. Open **Amazon API Gateway** in the AWS Console.
2. Create a new HTTP API named `RoughLifeRoomHttpApi`.
3. Create a `/room` route with the `POST` method.
4. Integrate the `/room` route with the `RoughLifeRoomApi` Lambda function.
5. Configure CORS so the Unity Client or HTTP test tools can call the API.
6. Deploy the API to the `$default` stage.
7. Copy the Invoke URL from API Gateway.
8. Test the API using `curl` from CMD.

---

#### API Gateway Overview Evidence

![API Gateway overview](/images/5-Workshop/5.9-api-gateway/08_01_API_Gateway_Overview.png)

The image above shows that the `RoughLifeRoomHttpApi` HTTP API was created successfully. The API has a default endpoint and is deployed in the **Asia Pacific Singapore** region.

This API acts as the main HTTP gateway for the RoughLife Unity Client to communicate with the serverless backend.

---

#### POST /room Route Evidence

![API Gateway route POST room](/images/5-Workshop/5.9-api-gateway/08_02_API_Gateway_Route_POST_room.png)

The image above shows the `/room` route with the `POST` method. This is the main endpoint that the Unity Client will call for room system requests.

The main actions sent to the `/room` route include:

- `create`: creates a new game room.
- `list`: returns the list of open rooms.
- `savePlayer`: saves player data.
- `saveMatchResult`: saves match result data.

Example create room request:

- `action`: `create`
- `playerName`: `Le`
- `playerId`: `player-demo-001`

Example list room request:

- `action`: `list`

Example player save request:

- `action`: `savePlayer`
- `playerId`: `player-demo-001`
- `displayName`: `Le`

Example match result request:

- `action`: `saveMatchResult`
- `matchId`: `match-demo-001`
- `roomCode`: `AB12CD`
- `bossId`: `Minotaur`
- `result`: `WIN`

---

#### CORS Evidence

![API Gateway CORS](/images/5-Workshop/5.9-api-gateway/08_03_API_Gateway_CORS.png)

The image above shows the CORS configuration for API Gateway.

The CORS configuration includes:

- **Access-Control-Allow-Origin**: allows origins to call the API.
- **Access-Control-Allow-Headers**: allows `content-type` and `authorization`.
- **Access-Control-Allow-Methods**: allows `POST`, `OPTIONS`, and `GET`.

This configuration allows the client or HTTP testing tools to call the API without being blocked by Cross-Origin Resource Sharing rules.

---

#### Stage and Invoke URL Evidence

![API Gateway stage invoke URL](/images/5-Workshop/5.9-api-gateway/08_04_API_Gateway_Stage_Invoke_URL.png)

The image above shows that the `$default` stage was deployed successfully. API Gateway provides an Invoke URL that clients can use to call the API.

The Invoke URL format is:

`https://<api-id>.execute-api.ap-southeast-1.amazonaws.com`

The complete endpoint for the `/room` route is:

`https://<api-id>.execute-api.ap-southeast-1.amazonaws.com/room`

This endpoint will be used by the Unity Client to send room creation, room listing, and online data requests.

---

#### CMD API Test

![CMD test list room](/images/5-Workshop/5.9-api-gateway/08_05_CMD_Test_ListRoom.png)

The image above shows the API Gateway test using the `curl` command from CMD. The request sends the `list` action to the `/room` endpoint, and the API returns the available room list.

The test command format is:

`curl -X POST "https://<api-id>.execute-api.ap-southeast-1.amazonaws.com/room" -H "Content-Type: application/json" -d "{\"action\":\"list\"}"`

The response returns `ok: true` and a list of rooms. This proves that API Gateway is connected to Lambda and Lambda can read data from DynamoDB.

---

#### Role of API Gateway in the RoughLife System

API Gateway gives the RoughLife online system a clearer backend layer instead of letting the client directly call Lambda or access the database.

In the current architecture, API Gateway is responsible for:

- Providing a public HTTP endpoint for the Unity Client.
- Forwarding client requests to the Lambda backend.
- Supporting CORS configuration for client access.
- Preparing the system for Cognito JWT authentication integration.
- Making it easier to extend the backend with additional APIs such as matchmaking, player profile, or match history.

---

#### Result

After this step, the team successfully exposed the Room API through Amazon API Gateway. The Unity Client can call the `/room` endpoint to create rooms, list rooms, save player data, and save match results.

Using API Gateway brings the RoughLife system closer to a real online multiplayer backend architecture. It acts as an important middle layer between the Unity Client, Lambda backend, and DynamoDB.