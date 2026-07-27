import path from "node:path";
import { connect, listTabs, setupPage, screenshot, click, insertText, sleep, text } from "./cdp-aws-helper.mjs";

const command = process.argv.slice(2).join(" ");
if (!command) {
  console.error("Usage: node cdp-run-cloudshell-command.mjs <command>");
  process.exit(2);
}

const tabs = await listTabs();
const info = tabs.find((t) => (t.url || "").includes("cloudshell")) ?? tabs[0];
const client = await connect(info.webSocketDebuggerUrl);
await setupPage(client, 1280, 720);

// Close the welcome modal if it is present.
await click(client, 1390, 778).catch(() => {});
await sleep(1000);

// Focus the terminal near the visible prompt and send command.
await click(client, 58, 148);
await sleep(500);
await insertText(client, `${command}\n`);
await sleep(5000);

await screenshot(client, path.resolve("aws-workshop/screenshots-000006-rerun-wide/00-cloudshell-command-test.png"));
console.log((await text(client)).slice(-3000));
client.close();
