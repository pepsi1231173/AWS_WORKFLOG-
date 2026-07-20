import { connect, listTabs, setupPage, click, insertText, press, sleep, screenshot } from "./cdp-aws-helper.mjs";
import path from "node:path";

const tabs = await listTabs();
const info = tabs.find((t) => (t.url || "").includes("cloudshell")) ?? tabs[0];
const client = await connect(info.webSocketDebuggerUrl);
await setupPage(client, 1280, 720);
await click(client, 80, 342);
await sleep(300);
await press(client, "Escape");
await sleep(300);
await insertText(client, ":q!\n");
await sleep(1000);
await screenshot(client, path.resolve(process.argv[2] || "aws-workshop/screenshots-000006-rerun-wide/05-exit-editor.png"));
client.close();
