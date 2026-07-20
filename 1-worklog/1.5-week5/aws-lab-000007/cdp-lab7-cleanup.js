const fs = require("fs");
const http = require("http");

const OUT_DIR = "D:/RoughLife GAME/RoughLife/aws-lab-000007/screenshots-ui";
const CLOUDSHELL_URL = "https://ap-southeast-1.console.aws.amazon.com/cloudshell/home?region=ap-southeast-1";

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

function wait(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function getCloudShellPage() {
  const targets = await getJson("http://127.0.0.1:9222/json/list");
  return targets.find((p) => p.type === "page" && p.url.includes("cloudshell/home")) ||
    targets.find((p) => p.type === "page" && p.url.includes("console.aws.amazon.com"));
}

async function pasteCommand(send, command) {
  await send("Browser.grantPermissions", {
    origin: "https://ap-southeast-1.console.aws.amazon.com",
    permissions: ["clipboardReadWrite", "clipboardSanitizedWrite"],
  }).catch(() => {});
  await send("Runtime.evaluate", {
    expression: `navigator.clipboard.writeText(${JSON.stringify(command)})`,
    awaitPromise: true,
    returnByValue: true,
  });
  await send("Runtime.evaluate", {
    expression: "document.querySelector('.ace_editor.terminal.ace_focus textarea, .ace_editor.terminal textarea')?.focus();",
  }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 90, y: 238, button: "left", clickCount: 1 }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 90, y: 238, button: "left", clickCount: 1 }).catch(() => {});
  await wait(500);
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Control", code: "ControlLeft", windowsVirtualKeyCode: 17, modifiers: 2 });
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "v", code: "KeyV", windowsVirtualKeyCode: 86, modifiers: 2 });
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "v", code: "KeyV", windowsVirtualKeyCode: 86, modifiers: 2 });
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Control", code: "ControlLeft", windowsVirtualKeyCode: 17 });
  await wait(1500);
  await send("Runtime.evaluate", {
    expression: `(() => {
      const btn = [...document.querySelectorAll('button')].find((el) => {
        const r = el.getBoundingClientRect();
        return r.width > 0 && r.height > 0 && (el.innerText || '').trim() === 'Paste';
      });
      if (btn) btn.click();
      return Boolean(btn);
    })()`,
    returnByValue: true,
  }).catch(() => {});
}

async function screenshot(send, filename) {
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: true }, 120000);
  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.writeFileSync(`${OUT_DIR}/${filename}`, Buffer.from(shot.result.data, "base64"));
  console.log(`${OUT_DIR}/${filename}`);
}

async function bodyText(send) {
  const res = await send("Runtime.evaluate", {
    expression: "document.body ? document.body.innerText : ''",
    returnByValue: true,
  });
  return res.result.result.value || "";
}

async function main() {
  const target = await getCloudShellPage();
  if (!target) throw new Error("No AWS console page on CDP port 9222");
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable");
  await send("Page.bringToFront").catch(() => {});
  await send("Emulation.setDeviceMetricsOverride", { width: 1280, height: 720, deviceScaleFactor: 1, mobile: false }).catch(() => {});
  await send("Page.navigate", { url: CLOUDSHELL_URL }, 60000);
  await wait(8000);
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Escape", code: "Escape", windowsVirtualKeyCode: 27 }).catch(() => {});
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Escape", code: "Escape", windowsVirtualKeyCode: 27 }).catch(() => {});

  const labScript = fs.readFileSync("D:/RoughLife GAME/RoughLife/aws-lab-000007/lab7-budgets-cleanup.sh", "utf8");
  const command = `cat > lab7-budgets-cleanup.sh <<'EOF'\n${labScript}\nEOF\nchmod +x lab7-budgets-cleanup.sh\n./lab7-budgets-cleanup.sh 2>&1 | tee lab7-budgets-cleanup.log\n`;
  await pasteCommand(send, command);

  let text = "";
  for (let i = 0; i < 8; i++) {
    await wait(10000);
    text = await bodyText(send).catch(() => "");
    if (text.includes("LAB7_CLEANUP_DONE LAB7-0704")) break;
  }
  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.writeFileSync(`${OUT_DIR}/lab7-cleanup-cloudshell-text.txt`, text);
  await screenshot(send, "08-cloudshell-cleanup-done.png");
  console.log(text.slice(-2000));
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
