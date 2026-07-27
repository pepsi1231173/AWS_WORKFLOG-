import path from "node:path";
import { newTab, setupPage, navigate, click, sleep, screenshot } from "./cdp-aws-helper.mjs";

const outDir = process.argv[2] || "aws-workshop/screenshots-000006-final-1280";
const client = await newTab("about:blank");
await setupPage(client, 1280, 720);
await navigate(client, "https://ap-southeast-1.console.aws.amazon.com/ec2/home?region=ap-southeast-1#AutoScalingGroups:", 18000).catch(() => {});
await click(client, 437, 303);
await sleep(10000);
await click(client, 655, 465);
await sleep(8000);
await screenshot(client, path.resolve(outDir, "14-asg-automatic-scaling.png"));
client.close();
