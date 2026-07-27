import path from "node:path";
import { connect, listTabs, setupPage, screenshot, text, sleep } from "./cdp-aws-helper.mjs";

const outDir = process.argv[2] || "aws-workshop/screenshots-000006-rerun-wide";
const tabs = (await listTabs()).filter((t) => (t.url || "").includes("cloudshell"));
let i = 0;
for (const info of tabs) {
  const client = await connect(info.webSocketDebuggerUrl);
  await setupPage(client, 1280, 720);
  await sleep(1000);
  const file = path.resolve(outDir, `tab-${i}-${info.id.slice(0, 6)}.png`);
  await screenshot(client, file);
  console.log(JSON.stringify({ i, id: info.id, title: info.title, url: info.url, file, text: (await text(client)).slice(-500) }, null, 2));
  client.close();
  i += 1;
}
