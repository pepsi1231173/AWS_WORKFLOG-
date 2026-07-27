import path from "node:path";
import { connect, listTabs, setupPage, click, sleep, screenshot, text } from "./cdp-aws-helper.mjs";

const x = Number(process.argv[2]);
const y = Number(process.argv[3]);
const out = process.argv[4] || "aws-workshop/screenshots-000006-rerun-wide/00-click-result.png";
if (!Number.isFinite(x) || !Number.isFinite(y)) {
  console.error("Usage: node cdp-click.mjs <x> <y> [screenshot]");
  process.exit(2);
}

const tabs = await listTabs();
const info = tabs.find((t) => (t.url || "").includes("cloudshell")) ?? tabs[0];
const client = await connect(info.webSocketDebuggerUrl);
await setupPage(client, 2048, 1152);
await click(client, x, y);
await sleep(2500);
await screenshot(client, path.resolve(out));
console.log((await text(client)).slice(-1200));
client.close();
setTimeout(() => process.exit(0), 100);
