import { readFile } from "node:fs/promises";
import { connect, listTabs, setupPage, click, insertText, sleep, screenshot } from "./cdp-aws-helper.mjs";
import path from "node:path";

const file = process.argv[2];
if (!file) {
  console.error("Usage: node cdp-paste-file.mjs <text-file>");
  process.exit(2);
}

const payload = await readFile(file, "utf8");
const tabs = await listTabs();
const info = tabs.find((t) => (t.url || "").includes("cloudshell")) ?? tabs[0];
const client = await connect(info.webSocketDebuggerUrl);
await setupPage(client, 1280, 720);
await click(client, 58, 148);
await sleep(500);
await insertText(client, payload);
await sleep(3000);
await screenshot(client, path.resolve("aws-workshop/screenshots-000006-rerun-wide/00-paste-file-result.png"));
client.close();
