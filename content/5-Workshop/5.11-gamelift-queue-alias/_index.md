---
title: "GameLift Alias and Game Session Queue Setup"
date: 2024-01-01
weight: 11
chapter: false
pre: " <b> 5.11. </b> "
---

#### Objective

In this step, the team designs the next Amazon GameLift components for the RoughLife online multiplayer system: **Fleet Alias** and **Game Session Queue**.

In the complete architecture, Alias and Queue are used to separate the backend logic from direct Fleet ID usage. Instead of calling a specific fleet directly, the backend can use a Queue or Alias to make fleet replacement, scaling, and server version updates easier.

The planned flow is:

1. Unity Client sends a create room request to API Gateway.
2. API Gateway invokes the `RoughLifeRoomApi` Lambda function.
3. Lambda calls the GameLift Game Session Queue.
4. GameLift selects the appropriate fleet and creates a Game Session.
5. GameLift returns IP, Port, and PlayerSessionId.
6. Unity Client uses this information to connect to the dedicated server through UDP.

---

#### Planned Fleet Alias Design

The planned Fleet Alias configuration is:

- Alias name: `RoughLife-FleetAlias-Dev`
- Routing strategy: points to a GameLift Managed EC2 Fleet or Anywhere Fleet.
- Purpose: prevents the backend from depending directly on a Fleet ID.

When a real fleet is available, the Alias will be linked to the active fleet. If the team needs to deploy a new server version or switch to another fleet, the Alias can be updated without changing the Unity Client or Lambda logic.

---

#### Planned Game Session Queue Design

The planned Game Session Queue configuration is:

- Queue name: `RoughLife-GameSessionQueue-Dev`
- Destination: Fleet Alias or Fleet ARN.
- Region: `ap-southeast-1`
- Timeout: default value or adjusted for testing.
- Purpose: selects a suitable fleet destination for creating Game Sessions.

The Queue helps the system become more scalable in the future. When multiple fleets or locations are available, the GameLift Queue can route game session placement to the most suitable destination.

---

#### Current Status

At the time of this report, the team could not create the Fleet Alias and Game Session Queue completely because the current AWS account has not been granted quota to create a GameLift Fleet.

The previous evidence shows the following issue:

![GameLift fleet quota error](/images/5-Workshop/5.11-gamelift-queue-alias/10_07_GameLift_FleetQuota_Error.png)

AWS returned an error when creating the Managed EC2 Fleet because the current fleet limit is 0.

![Service quota increase request](/images/5-Workshop/5.11-gamelift-queue-alias/10_09_ServiceQuota_Increase_Request.png)

The team checked Service Quotas and prepared a quota increase request so that fleets can be created in the `ap-southeast-1` region.

![GameLift Anywhere quota error](/images/5-Workshop/5.11-gamelift-queue-alias/10A_02_GameLift_FleetQuota_Error.png)

The team also tested the GameLift Anywhere approach, but Anywhere fleet creation was also blocked by the current fleet quota limit.

Because Alias and Queue require a fleet or fleet alias destination to work properly, this step can only be completed after AWS approves the quota request and a fleet is created successfully.

---

#### Completion Plan After Quota Approval

After AWS grants the required GameLift Fleet quota, the team will complete the following steps:

1. Create a Managed EC2 Fleet from the `RoughLifeServer` build.
2. Wait until the fleet becomes Active.
3. Create the Fleet Alias `RoughLife-FleetAlias-Dev`.
4. Link the Alias to the active fleet.
5. Create the Game Session Queue `RoughLife-GameSessionQueue-Dev`.
6. Add the Alias or Fleet ARN as the Queue destination.
7. Update the `RoughLifeRoomApi` Lambda function to call GameLift Queue instead of using a mock server address.
8. Test Game Session creation and receive IP, Port, and PlayerSessionId.
9. Allow the Unity Client to connect to the dedicated server through UDP.

---

#### Result

Due to the AWS account quota limitation, the team could not create the Fleet Alias and Game Session Queue at this stage. However, the team completed the important preparation work, including server build upload, fleet configuration, runtime configuration, UDP port configuration, Service Quotas verification, and quota increase request preparation.

The Alias and Queue setup will be completed after AWS grants the required fleet quota. In the final architecture, Fleet Alias and Game Session Queue are important components that allow RoughLife to scale, switch fleets flexibly, and allocate game sessions using a real dedicated server hosting model.