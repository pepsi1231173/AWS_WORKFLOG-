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
  await send("Browser.grantPermissions", {
    origin: "https://ap-southeast-1.console.aws.amazon.com",
    permissions: ["clipboardReadWrite", "clipboardSanitizedWrite"],
  }).catch(() => {});
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Escape", code: "Escape", windowsVirtualKeyCode: 27 }).catch(() => {});
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Escape", code: "Escape", windowsVirtualKeyCode: 27 }).catch(() => {});
  await send("Runtime.evaluate", {
    expression: `navigator.clipboard.writeText('echo LAB7_CLIP_TEST\\\\n').then(()=>true).catch(e=>'ERR '+e.message)`,
    awaitPromise: true,
    returnByValue: true,
  });
  await send("Runtime.evaluate", { expression: "document.querySelector('.ace_editor.terminal.ace_focus textarea, .ace_editor.terminal textarea')?.focus();" }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 90, y: 650, button: "left", clickCount: 1 });
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 90, y: 650, button: "left", clickCount: 1 });
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Control", code: "ControlLeft", windowsVirtualKeyCode: 17, modifiers: 2 });
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "v", code: "KeyV", windowsVirtualKeyCode: 86, modifiers: 2 });
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "v", code: "KeyV", windowsVirtualKeyCode: 86, modifiers: 2 });
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Control", code: "ControlLeft", windowsVirtualKeyCode: 17 });
  await new Promise((resolve) => setTimeout(resolve, 2000));
  const visible = await send("Runtime.evaluate", {
    expression: `(() => [...document.querySelectorAll('button,textarea')].map((el,i)=>{const r=el.getBoundingClientRect();return {i,text:(el.innerText||el.value||el.getAttribute('aria-label')||'').slice(0,80),x:r.x,y:r.y,w:r.width,h:r.height,shown:r.width>0&&r.height>0}}).filter(x=>x.shown||x.text.includes('Paste')||x.text.includes('LAB7')))()`,
    returnByValue: true,
  });
  console.log(JSON.stringify(visible.result.result.value, null, 2));
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: false }, 120000);
  fs.writeFileSync("D:/RoughLife GAME/RoughLife/aws-lab-000007/screenshots-ui/clipboard-test.png", Buffer.from(shot.result.data, "base64"));
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
