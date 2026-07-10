const http = require("http");

const command = process.argv.slice(2).join(" ");
if (!command) {
  console.error("Usage: node cdp-cloudshell-command.js <command>");
  process.exit(1);
}

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

async function main() {
  const targets = await getJson("http://127.0.0.1:9222/json/list");
  const target = targets.find((p) => p.type === "page" && p.url.includes("cloudshell/home"));
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable").catch(() => {});
  await send("Page.bringToFront").catch(() => {});
  await send("Emulation.setDeviceMetricsOverride", { width: 2048, height: 1152, deviceScaleFactor: 1, mobile: false }).catch(() => {});
  await send("Runtime.evaluate", {
    expression: `(() => {
      const btn = [...document.querySelectorAll('button, [role="button"]')].find((el) => /^(Close|Reconnect)$/i.test((el.innerText || '').trim()));
      if (btn) btn.click();
      return Boolean(btn);
    })()`,
    returnByValue: true,
  }, 10000).catch(() => {});
  await new Promise((resolve) => setTimeout(resolve, 2000));
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 70, y: 237, button: "left", clickCount: 1 }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 70, y: 237, button: "left", clickCount: 1 }).catch(() => {});
  await send("Input.insertText", { text: `${command}\n` }, 30000);
  ws.close();
  console.log(`sent command: ${command}`);
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
