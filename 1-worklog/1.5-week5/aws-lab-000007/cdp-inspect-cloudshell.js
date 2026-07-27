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
  if (!target) throw new Error("CloudShell page not found");
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Runtime.enable");
  const res = await send("Runtime.evaluate", {
    expression: `(() => {
      const els = [...document.querySelectorAll('textarea,input,[contenteditable=true],.xterm,.xterm-helper-textarea,.terminal')];
      return {
        url: location.href,
        active: document.activeElement ? {tag: document.activeElement.tagName, cls: document.activeElement.className, aria: document.activeElement.getAttribute('aria-label')} : null,
        elements: els.map((el, i) => {
          const r = el.getBoundingClientRect();
          return {i, tag: el.tagName, cls: String(el.className), aria: el.getAttribute('aria-label'), role: el.getAttribute('role'), x:r.x, y:r.y, w:r.width, h:r.height, value: el.value?.slice?.(0,80)};
        }),
        textTail: document.body.innerText.slice(-2000)
      };
    })()`,
    returnByValue: true,
  });
  const value = res.result.result.value;
  console.log(JSON.stringify(value, null, 2));
  fs.writeFileSync("D:/RoughLife GAME/RoughLife/aws-lab-000007/cloudshell-dom-inspect.json", JSON.stringify(value, null, 2));
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
