import path from "node:path";
import { newTab, setupPage, navigate, screenshot, text, sleep } from "./cdp-aws-helper.mjs";

const outDir = path.resolve("aws-workshop/screenshots-000006-rerun-wide");
const client = await newTab("about:blank");
await setupPage(client, 2048, 1152);
await navigate(client, "https://ap-southeast-1.console.aws.amazon.com/cloudshell/home?region=ap-southeast-1", 12000);
await sleep(8000);
await screenshot(client, path.join(outDir, "00-cloudshell-state.png"));
console.log((await text(client)).slice(0, 3000));
client.close();
