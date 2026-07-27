import path from "node:path";
import { connect, listTabs, setupPage, screenshot, text } from "./cdp-aws-helper.mjs";

const file = process.argv[2] || "aws-workshop/screenshots-000006-rerun-wide/current.png";
const width = Number(process.argv[3] || 1280);
const height = Number(process.argv[4] || 720);
const tabs = await listTabs();
const info = tabs.find((t) => (t.url || "").includes("cloudshell")) ?? tabs[0];
const client = await connect(info.webSocketDebuggerUrl);
await setupPage(client, width, height);
await screenshot(client, path.resolve(file));
console.log((await text(client)).slice(-3000));
client.close();
setTimeout(() => process.exit(0), 100);
