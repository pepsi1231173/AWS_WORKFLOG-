const fs = require("fs");
const http = require("http");

const OUT_DIR = "D:/RoughLife GAME/RoughLife/aws-lab-000007/screenshots-ui";
const URL = "https://us-east-1.console.aws.amazon.com/costmanagement/home#/budgets";

function getJson(url) {
  return new Promise((resolve, reject) => {
    http.get(url, (res) => {
      let data = "";
      res.on("data", (chunk) => (data += chunk));
      res.on("end", () => resolve(JSON.parse(data)));
    }).on("error", reject);
  });
}

async function connect(wsUrl) {
  const ws = new WebSocket(wsUrl);
  let id = 0;
  const pending = new Map();
  ws.onmessage = (event) => {
    const msg = JSON.parse(event.data);
    if (msg.id && pending.has(msg.id)) {
      pending.get(msg.id).resolve(msg);
      pending.delete(msg.id);
    }
  };
  await new Promise((resolve, reject) => {
    ws.onopen = resolve;
    ws.onerror = reject;
    setTimeout(() => reject(new Error("WebSocket open timeout")), 5000);
  });
  function send(method, params = {}, timeoutMs = 60000) {
    return new Promise((resolve, reject) => {
      const callId = ++id;
      pending.set(callId, { resolve, reject });
      ws.send(JSON.stringify({ id: callId, method, params }));
      setTimeout(() => {
        if (pending.has(callId)) {
          pending.delete(callId);
          reject(new Error(`${method} timeout`));
        }
      }, timeoutMs);
    });
  }
  return { ws, send };
}

async function main() {
  const targets = await getJson("http://127.0.0.1:9222/json/list");
  const target = targets.find((p) => p.type === "page" && p.url.includes("costmanagement/home")) ||
    targets.find((p) => p.type === "page" && p.url.includes("console.aws.amazon.com"));
  if (!target) throw new Error("No AWS console page found");
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable");
  await send("Page.bringToFront").catch(() => {});
  await send("Emulation.setDeviceMetricsOverride", { width: 1280, height: 720, deviceScaleFactor: 1, mobile: false }).catch(() => {});
  await send("Page.navigate", { url: URL }, 60000);
  await new Promise((resolve) => setTimeout(resolve, 18000));
  await send("Runtime.evaluate", {
    expression: `(() => {
      const input = [...document.querySelectorAll('input')].find((el) => /find|budget|search|filter/i.test(el.placeholder || el.getAttribute('aria-label') || ''));
      if (input) {
        input.focus();
        input.value = 'LAB7-0704';
        input.dispatchEvent(new Event('input', {bubbles:true}));
        input.dispatchEvent(new Event('change', {bubbles:true}));
      }
    })()`,
  }).catch(() => {});
  await new Promise((resolve) => setTimeout(resolve, 4000));
  const text = await send("Runtime.evaluate", { expression: "document.body ? document.body.innerText : ''", returnByValue: true });
  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.writeFileSync(`${OUT_DIR}/09-budget-list-after-cleanup.txt`, text.result.result.value || "");
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: true }, 120000);
  fs.writeFileSync(`${OUT_DIR}/09-budget-list-after-cleanup.png`, Buffer.from(shot.result.data, "base64"));
  console.log(`${OUT_DIR}/09-budget-list-after-cleanup.png`);
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
