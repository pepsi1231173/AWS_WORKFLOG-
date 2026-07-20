const fs = require("fs");
const http = require("http");

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
  function send(method, params = {}, timeoutMs = 30000) {
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

async function clickVisibleText(send, selector, text) {
  const res = await send("Runtime.evaluate", {
    expression: `(() => {
      const els = [...document.querySelectorAll(${JSON.stringify(selector)})];
      const el = els.find(e => {
        const r = e.getBoundingClientRect();
        return r.width > 0 && r.height > 0 && (e.innerText || e.textContent || '').trim() === ${JSON.stringify(text)};
      });
      if (!el) return false;
      el.click();
      return true;
    })()`,
    returnByValue: true,
  });
  return Boolean(res.result.result.value);
}

async function main() {
  const targets = await getJson("http://127.0.0.1:9222/json/list");
  const target = targets.find((p) => p.type === "page" && p.url.includes("cloudshell/home"));
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable");
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Escape", code: "Escape", windowsVirtualKeyCode: 27 }).catch(() => {});
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Escape", code: "Escape", windowsVirtualKeyCode: 27 }).catch(() => {});
  await new Promise((resolve) => setTimeout(resolve, 500));
  await clickVisibleText(send, "button", "Actions");
  await new Promise((resolve) => setTimeout(resolve, 800));
  if (!(await clickVisibleText(send, "[role=menuitem],span", "Restart"))) {
    throw new Error("Restart menu item not found");
  }
  await new Promise((resolve) => setTimeout(resolve, 1000));
  await clickVisibleText(send, "button", "Restart");
  await new Promise((resolve) => setTimeout(resolve, 45000));
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: false }, 120000);
  fs.writeFileSync("D:/RoughLife GAME/RoughLife/aws-lab-000007/screenshots-ui/cloudshell-after-restart.png", Buffer.from(shot.result.data, "base64"));
  const text = await send("Runtime.evaluate", { expression: "document.body.innerText.slice(-1500)", returnByValue: true });
  console.log(text.result.result.value);
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
