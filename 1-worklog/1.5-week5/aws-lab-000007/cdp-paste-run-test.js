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
  await send("Runtime.enable");
  await send("Page.enable");
  await send("Browser.grantPermissions", {
    origin: "https://ap-southeast-1.console.aws.amazon.com",
    permissions: ["clipboardReadWrite", "clipboardSanitizedWrite"],
  }).catch(() => {});
  await send("Runtime.evaluate", {
    expression: `navigator.clipboard.writeText(${JSON.stringify("echo LAB7_PASTE_OK")})`,
    awaitPromise: true,
    returnByValue: true,
  });
  await send("Runtime.evaluate", { expression: "document.querySelector('.ace_editor.terminal.ace_focus textarea, .ace_editor.terminal textarea')?.focus();" }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 92, y: 238, button: "left", clickCount: 1 });
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 92, y: 238, button: "left", clickCount: 1 });
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Control", code: "ControlLeft", windowsVirtualKeyCode: 17, modifiers: 2 });
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "v", code: "KeyV", windowsVirtualKeyCode: 86, modifiers: 2 });
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "v", code: "KeyV", windowsVirtualKeyCode: 86, modifiers: 2 });
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Control", code: "ControlLeft", windowsVirtualKeyCode: 17 });
  await new Promise((resolve) => setTimeout(resolve, 500));
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Enter", code: "Enter", windowsVirtualKeyCode: 13 });
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Enter", code: "Enter", windowsVirtualKeyCode: 13 });
  await new Promise((resolve) => setTimeout(resolve, 2500));
  const out = await send("Runtime.evaluate", { expression: "document.body.innerText.slice(-800)", returnByValue: true });
  console.log(out.result.result.value);
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
