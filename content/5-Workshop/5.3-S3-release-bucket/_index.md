---
title: "S3 Release Bucket"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---

#### Objective

In this step, the team uses **Amazon S3** to store the release files of RoughLife. These files include the Windows client build, version metadata, and patch manifest. This storage layer is used as the foundation for client distribution and future patch/update delivery.

The uploaded files include:

- `RoughLife_Client_Window.zip`: the Windows client build of the game.
- `version.json`: a metadata file that describes the latest available version.
- `patch_manifest.json`: a manifest file that lists downloadable or updateable files.

Amazon S3 is used as the object storage service, while Amazon CloudFront will be configured in the next step to distribute these files through HTTPS.

#### Implementation Steps

1. Open the **Amazon S3** service in the AWS Console.
2. Create a new bucket named `roughlife-release-bucket-letran-20260709`.
3. Keep the bucket private and do not allow direct public access.
4. Prepare the release folder on the local machine with the following structure:

```text
RoughLifeRelease/
├── version.json
├── patch_manifest.json
└── builds/
    └── windows/
        └── RoughLife_Client_Window.zip
```

5. Upload the release files to the S3 bucket.
6. Verify the uploaded objects in the bucket.

#### S3 Release Bucket Evidence

![S3 release bucket](/images/5-Workshop/5.3-S3-release-bucket/02_S3_Release_Bucket.png)

The image above shows the S3 bucket created to store the RoughLife release files.

![S3 upload objects](/images/5-Workshop/5.3-S3-release-bucket/02_Upload.png)

The image above shows the upload process for `version.json`, `patch_manifest.json`, and the Windows client build file.

![S3 client zip](/images/5-Workshop/5.3-S3-release-bucket/02_S3_Client_Zip.png)

The image above shows the `RoughLife_Client_Window.zip` file prepared under the `builds/windows` folder. This file is the Windows client build that can be distributed to players.

#### Result

After this step, the S3 bucket contains all required release files. This bucket is used as the origin for the CloudFront Distribution in the next step.