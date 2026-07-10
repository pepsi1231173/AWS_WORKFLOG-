import { connect, listTabs, setupPage, click, sleep, screenshot } from "./cdp-aws-helper.mjs";
import path from "node:path";

const tabs = await listTabs();
const info = tabs.find((t) => (t.url || "").includes("cloudshell")) ?? tabs[0];
const client = await connect(info.webSocketDebuggerUrl);
await setupPage(client, 1280, 720);
await click(client, 60, 650);
await sleep(300);
await client.send("Input.dispatchKeyEvent", {
  type: "keyDown",
  key: "c",
  code: "KeyC",
  windowsVirtualKeyCode: 67,
  nativeVirtualKeyCode: 67,
  modifiers: 2
});
await client.send("Input.dispatchKeyEvent", {
  type: "keyUp",
  key: "c",
  code: "KeyC",
  windowsVirtualKeyCode: 67,
  nativeVirtualKeyCode: 67,
  modifiers: 2
});
await sleep(1500);
await screenshot(client, path.resolve(process.argv[2] || "aws-workshop/screenshots-000006-rerun-wide/02-ctrlc-focused.png"));
client.close();
