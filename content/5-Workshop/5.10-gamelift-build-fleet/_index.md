---
title: "Amazon GameLift Build and Fleet Setup"
date: 2024-01-01
weight: 10
chapter: false
pre: " <b> 5.10. </b> "
---

#### Objective

In this step, the team configures **Amazon GameLift Servers** to prepare the dedicated server hosting layer for RoughLife. GameLift is used in the target architecture to manage game servers, create game sessions, and provide connection information to players.

The objectives of this step are:

- Integrate the Amazon GameLift Server SDK into the Unity project.
- Build the Linux dedicated server.
- Upload the server build to Amazon GameLift.
- Create a Managed EC2 Fleet for running the server build.
- Configure runtime process, UDP port, and instance type for the fleet.
- Verify the AWS account quota limitation when creating the fleet.

During implementation, the team successfully uploaded the server build and the build reached the **Ready** status. However, when creating the fleet, AWS Console reported that the current fleet limit is 0. Therefore, the Managed EC2 Fleet could not be fully created in the current account.

---

#### Amazon GameLift Server SDK Integration in Unity

![Amazon GameLift SDK Unity](/images/5-Workshop/5.10-gamelift-build-fleet/Setup_AWSSDK_Unity.PNG)

The image above shows that the **Amazon GameLift Server SDK** package was imported into the Unity project. This is required for the dedicated server to communicate with GameLift, report server process status, and receive game session activations.

---

#### Uploading the Server Build to GameLift

![GameLift upload build CLI](/images/5-Workshop/5.10-gamelift-build-fleet/10_01_GameLift_UploadBuild_CLI.png)

The image above shows that the team used AWS CLI to upload the dedicated server build to Amazon GameLift.

The uploaded build information includes:

- Build name: `RoughLifeServer`
- Build version: `0.1.0`
- Operating system: `Amazon Linux 2023`
- Server SDK version: `5.5.0`
- Region: `ap-southeast-1`

After the upload completed successfully, AWS returned a Build ID. This proves that the server build was uploaded to GameLift and is ready for fleet deployment.

---

#### Build Status Verification

![GameLift build ready](/images/5-Workshop/5.10-gamelift-build-fleet/10_02_GameLift_Build_READY.png)

The image above shows that the `RoughLifeServer` build reached the **Ready** status. This confirms that Amazon GameLift successfully received and processed the server build.

---

#### Managed EC2 Fleet Configuration

![GameLift create fleet build selected](/images/5-Workshop/5.10-gamelift-build-fleet/10_03_GameLift_CreateFleet_BuildSelected.png)

The image above shows the Managed EC2 Fleet creation step. The team selected **Build** as the binary type and selected the uploaded `RoughLifeServer` build.

The fleet name is `RoughLife-Managed-Dev`, and it is intended to run the Unity Dedicated Server on GameLift Managed EC2.

---

#### Fleet Instance Configuration

![GameLift instance details](/images/5-Workshop/5.10-gamelift-build-fleet/10_04_GameLift_InstanceDetails.png)

The image above shows the instance configuration for the fleet.

The selected configuration includes:

- Location: `ap-southeast-1`
- Fleet type: `On-Demand`
- Instance type: `c6a.large`
- Architecture: `x86_64`

The team selected **On-Demand** instead of Spot to avoid Spot interruption during gameplay. This is more suitable for online game sessions that require stable server availability.

---

#### Runtime Process Configuration

![GameLift runtime configuration](/images/5-Workshop/5.10-gamelift-build-fleet/10_05_GameLift_RuntimeConfig_OneProcess.png)

The image above shows the runtime configuration for the server process.

The main runtime configuration includes:

- Launch path: `/local/game/RoughLifeServer.x86_64`
- Launch parameters: `-port 7777 -logFile /local/game/logs/server.log`
- Concurrent processes: `1`

This configuration means that each instance runs one RoughLife server process. The server process listens on UDP port 7777 for realtime gameplay traffic.

---

#### UDP Gameplay Port Configuration

![GameLift UDP port settings](/images/5-Workshop/5.10-gamelift-build-fleet/10_06_GameLift_PortSettings_UDP.png)

The image above shows the port configuration for the GameLift fleet.

The port settings are:

- Protocol: `UDP`
- Port range: `7777`
- IP address range: `0.0.0.0/0`

UDP port 7777 is used for realtime gameplay communication between the Unity Client and the dedicated server.

---

#### Managed EC2 Fleet Quota Error

![GameLift fleet quota error](/images/5-Workshop/5.10-gamelift-build-fleet/10_07_GameLift_FleetQuota_Error.png)

The image above shows the error when submitting the fleet creation form. AWS reported that the current fleet limit is 0, so the Managed EC2 Fleet could not be created.

This means that the fleet configuration was prepared correctly, but the current AWS account has not been granted fleet creation quota in the selected region.

---

#### Service Quotas Verification

![Service quotas GameLift fleet](/images/5-Workshop/5.10-gamelift-build-fleet/10_08_ServiceQuotas_GameLift_ManagedEC2Fleets_0.png)

The image above shows the **Service Quotas** page for Amazon GameLift Servers. The team checked the Managed EC2 fleets per region quota to verify the cause of the fleet creation error.

---

#### Quota Increase Request

![Service quota increase request](/images/5-Workshop/5.10-gamelift-build-fleet/10_09_ServiceQuota_Increase_Request.png)

The image above shows the quota increase request form for Managed EC2 fleets. This request is required for AWS to review and grant fleet creation capability to the account.

---

#### GameLift Anywhere Attempt

![GameLift custom location](/images/5-Workshop/5.10-gamelift-build-fleet/10A_01_GameLift_CustomLocation.png)

The image above shows that the team created a custom location named `custom-roughlife-home-lab` in GameLift Anywhere. GameLift Anywhere can be used to register game servers running outside GameLift Managed EC2, such as local lab machines or self-managed servers.

![GameLift Anywhere quota error](/images/5-Workshop/5.10-gamelift-build-fleet/10A_02_GameLift_FleetQuota_Error.png)

However, when creating an Anywhere fleet, AWS still reported that the current fleet limit is 0. Therefore, the GameLift Anywhere approach could not be completed in the current account.

---

#### Result

After this step, the team completed the important preparation tasks for GameLift:

- The Amazon GameLift Server SDK was integrated into Unity.
- The Linux dedicated server build was created.
- The server build was uploaded to Amazon GameLift using AWS CLI.
- The `RoughLifeServer` build reached the **Ready** status.
- The Managed EC2 Fleet configuration was prepared with build, instance type, runtime process, and UDP port.
- The AWS account quota limitation was identified.
- Service Quotas were checked and a quota increase request was prepared.
- GameLift Anywhere was also tested but blocked by the same fleet quota limitation.

Due to the AWS account quota limitation, the team could not create a real fleet at this stage. However, the evidence shows that the server build is ready to be deployed to GameLift once AWS grants the required quota.