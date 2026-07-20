import path from "node:path";
import { newTab, setupPage, navigate, screenshot, text } from "./cdp-aws-helper.mjs";

const outDir = path.resolve("aws-workshop/screenshots-000006-rerun-wide");
const client = await newTab("about:blank");
await setupPage(client, 2048, 1152);
await navigate(client, "https://ap-southeast-1.console.aws.amazon.com/console/home?region=ap-southeast-1", 10000);
await screenshot(client, path.join(outDir, "00-console-home-test.png"));
const body = await text(client);
console.log(body.slice(0, 1000));
