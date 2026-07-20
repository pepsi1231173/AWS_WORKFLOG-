import { connect, listTabs, setupPage, press, sleep, screenshot } from "./cdp-aws-helper.mjs";
import path from "node:path";

const key = process.argv[2] || "c";
const modifiers = Number(process.argv[3] || 0);
const tabs = await listTabs();
const info = tabs.find((t) => (t.url || "").includes("cloudshell")) ?? tabs[0];
const client = await connect(info.webSocketDebuggerUrl);
await setupPage(client, 2048, 1152);
if (modifiers) {
  await client.send("Input.dispatchKeyEvent", { type: "keyDown", key, code: `Key${key.toUpperCase()}`, windowsVirtualKeyCode: key.toUpperCase().charCodeAt(0), nativeVirtualKeyCode: key.toUpperCase().charCodeAt(0), modifiers });
  await client.send("Input.dispatchKeyEvent", { type: "keyUp", key, code: `Key${key.toUpperCase()}`, windowsVirtualKeyCode: key.toUpperCase().charCodeAt(0), nativeVirtualKeyCode: key.toUpperCase().charCodeAt(0), modifiers });
} else {
  await press(client, key);
}
await sleep(1500);
await screenshot(client, path.resolve("aws-workshop/screenshots-000006-rerun-wide/00-key-result.png"));
client.close();
