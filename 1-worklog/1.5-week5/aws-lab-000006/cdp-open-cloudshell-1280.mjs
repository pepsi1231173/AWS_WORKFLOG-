import path from "node:path";
import { newTab, setupPage, navigate, screenshot, text, sleep } from "./cdp-aws-helper.mjs";

const out = process.argv[2] || "aws-workshop/screenshots-000006-rerun-wide/02-new-cloudshell-tab.png";
const client = await newTab("about:blank");
await setupPage(client, 1280, 720);
await navigate(client, "https://ap-southeast-1.console.aws.amazon.com/cloudshell/home?region=ap-southeast-1", 15000);
await sleep(10000);
await screenshot(client, path.resolve(out));
console.log((await text(client)).slice(-1500));
client.close();
