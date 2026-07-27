import path from "node:path";
import { newTab, setupPage, navigate, screenshot, sleep, text } from "./cdp-aws-helper.mjs";

const url = process.argv[2];
const out = process.argv[3];
const waitMs = Number(process.argv[4] || 12000);
if (!url || !out) {
  console.error("Usage: node cdp-capture-url.mjs <url> <out> [waitMs]");
  process.exit(2);
}

const client = await newTab("about:blank");
await setupPage(client, 1280, 720);
await navigate(client, url, 20000).catch(() => {});
await sleep(waitMs);
await screenshot(client, path.resolve(out));
console.log((await text(client)).slice(0, 1000));
await client.send("Target.closeTarget", { targetId: client.targetId }).catch(() => {});
client.close();
