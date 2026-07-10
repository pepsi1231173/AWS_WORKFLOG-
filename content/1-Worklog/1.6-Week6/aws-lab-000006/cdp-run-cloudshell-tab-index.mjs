import path from "node:path";
import { connect, listTabs, setupPage, click, insertText, sleep, screenshot, text } from "./cdp-aws-helper.mjs";

const index = Number(process.argv[2] || 0);
const command = process.argv.slice(3).join(" ");
const tabs = (await listTabs()).filter((t) => (t.url || "").includes("cloudshell"));
const info = tabs[index] || tabs[0];
if (!info) throw new Error("No CloudShell tab found");
const client = await connect(info.webSocketDebuggerUrl);
await setupPage(client, 1280, 720);
// Dismiss the welcome modal when present.
await click(client, 736, 623).catch(() => {});
await sleep(1000);
if (command) {
  await click(client, 58, 148);
  await sleep(500);
  await insertText(client, `${command}\n`);
  await sleep(6000);
}
const out = path.resolve(`aws-workshop/screenshots-000006-rerun-wide/tab-${index}-command.png`);
await screenshot(client, out);
console.log((await text(client)).slice(-2500));
client.close();
