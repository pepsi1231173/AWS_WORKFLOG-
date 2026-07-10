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

async function main() {
  const targets = await getJson("http://127.0.0.1:9222/json/list");
  const target = targets.find((p) => p.type === "page" && p.url.includes("cloudshell/home"));
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable");
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 1170, y: 70, button: "left", clickCount: 1 });
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 1170, y: 70, button: "left", clickCount: 1 });
  await new Promise((resolve) => setTimeout(resolve, 1000));
  const res = await send("Runtime.evaluate", {
    expression: `(() => {
      const visible = [...document.querySelectorAll('button,a,[role=menuitem],textarea,input')].map((el, i) => {
        const r = el.getBoundingClientRect();
        const txt = (el.innerText || el.value || el.getAttribute('aria-label') || '').trim();
        return {i, tag:el.tagName, role:el.getAttribute('role'), text:txt.slice(0,100), x:r.x, y:r.y, w:r.width, h:r.height, shown:r.width>0&&r.height>0};
      }).filter(x => x.shown || x.text);
      return {tail: document.body.innerText.slice(-3000), visible};
    })()`,
    returnByValue: true,
  });
  console.log(JSON.stringify(res.result.result.value, null, 2));
  fs.writeFileSync("D:/RoughLife GAME/RoughLife/aws-lab-000007/actions-inspect.json", JSON.stringify(res.result.result.value, null, 2));
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: false }, 120000);
  fs.writeFileSync("D:/RoughLife GAME/RoughLife/aws-lab-000007/screenshots-ui/actions-menu.png", Buffer.from(shot.result.data, "base64"));
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
