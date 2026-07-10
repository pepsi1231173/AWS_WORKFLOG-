const fs = require("fs");
const http = require("http");

const OUT = "D:/RoughLife GAME/RoughLife/aws-lab-000004/screenshots-ui/09-iam-policies.png";
const TXT = `${OUT}.txt`;
const PREFIX = "LAB4-0705";

function getJson(url) {
  return new Promise((resolve, reject) => http.get(url, (res) => {
    let data = "";
    res.on("data", (chunk) => (data += chunk));
    res.on("end", () => resolve(JSON.parse(data)));
  }).on("error", reject));
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

function wait(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  let target = (await getJson("http://127.0.0.1:9222/json/list")).find((p) => p.type === "page" && p.url === "about:blank");
  if (!target) {
    target = await getJson("http://127.0.0.1:9222/json/new?about:blank");
  }
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable");
  await send("Page.bringToFront").catch(() => {});
  await send("Emulation.setDeviceMetricsOverride", { width: 1280, height: 720, deviceScaleFactor: 1, mobile: false }).catch(() => {});
  await send("Page.navigate", { url: "https://us-east-1.console.aws.amazon.com/iam/home#/policies" }, 60000);
  await wait(18000);
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 335, y: 211, button: "left", clickCount: 1 }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 335, y: 211, button: "left", clickCount: 1 }).catch(() => {});
  await wait(500);
  await send("Input.insertText", { text: PREFIX }, 30000);
  await wait(16000);
  const text = await send("Runtime.evaluate", { expression: "document.body ? document.body.innerText : ''", returnByValue: true }).catch(() => ({ result: { result: { value: "" } } }));
  fs.writeFileSync(TXT, `IAM policies filtered by ${PREFIX}\n\n${text.result.result.value || ""}`);
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: false }, 120000);
  fs.writeFileSync(OUT, Buffer.from(shot.result.data, "base64"));
  console.log(OUT);
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
