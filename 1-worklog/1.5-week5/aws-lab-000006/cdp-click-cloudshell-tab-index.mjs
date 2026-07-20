import path from "node:path";
import { connect, listTabs, setupPage, click, sleep, screenshot, text } from "./cdp-aws-helper.mjs";

const index = Number(process.argv[2] || 0);
const x = Number(process.argv[3]);
const y = Number(process.argv[4]);
const tabs = (await listTabs()).filter((t) => (t.url || "").includes("cloudshell"));
const info = tabs[index] || tabs[0];
const client = await connect(info.webSocketDebuggerUrl);
await setupPage(client, 1280, 720);
await click(client, x, y);
await sleep(3000);
const out = path.resolve(process.argv[5] || `aws-workshop/screenshots-000006-rerun-wide/tab-${index}-click.png`);
await screenshot(client, out);
console.log((await text(client)).slice(-1200));
client.close();
