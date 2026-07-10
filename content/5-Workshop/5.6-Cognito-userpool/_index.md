---
title: "Cognito User Pool"
date: 2024-01-01
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

#### Objective

In this step, the team creates an **Amazon Cognito User Pool** to prepare the player authentication system for RoughLife. Cognito User Pool can be used as a user directory for player registration, login, and token-based authentication.

For the RoughLife online system, Cognito can be used to:

- Register and authenticate players.
- Issue JWT tokens to the Unity client.
- Allow API Gateway to verify player identity before calling Room API or Matchmaking API.
- Link player identity with player save data stored in DynamoDB.

#### Implementation Steps

1. Open **Amazon Cognito** in the AWS Console.
2. Select **User pools**.
3. Create a new User Pool.
4. Configure the sign-in method using email or username.
5. Create an app client for the Unity Client.
6. Disable client secret for the Unity app client because the game client runs on the player's device.
7. Verify the User Pool ID and App Client ID.

#### Cognito User Pool Evidence

![Cognito user pool](/images/5-Workshop/5.6-Cognito-userpool/05_Cognito_UserPool.png)

The image above shows that the Cognito User Pool was created successfully in the Asia Pacific Singapore region. This User Pool is the foundation for implementing player login and JWT authentication in the next development phase.

#### Result

After this step, the system has a Cognito User Pool ready for player authentication. When integrated into the game, the Unity Client can authenticate through Cognito, receive a JWT token, and use that token to call backend APIs such as creating rooms, joining rooms, or saving player data.