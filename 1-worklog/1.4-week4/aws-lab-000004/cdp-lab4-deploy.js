const fs = require("fs");
const http = require("http");

const ROOT = "D:/RoughLife GAME/RoughLife/aws-lab-000004";
const OUT_DIR = `${ROOT}/screenshots-ui`;
const CLOUDSHELL_URL = "https://ap-southeast-1.console.aws.amazon.com/cloudshell/home?region=ap-southeast-1";

function getJson(url) {
  return new Promise((resolve, reject) => {
    http.get(url, (res) => {
      let data = "";
      res.on("data", (chunk) => (data += chunk));
      res.on("end", () => {
        try {
          resolve(JSON.parse(data));
        } catch (err) {
          reject(err);
        }
      });
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
    targets.find((p) => p.type === "page" && p.url.includes("console.aws.amazon.com")) ||
    targets.find((p) => p.type === "page");
}

async function bodyText(send) {
  const res = await send("Runtime.evaluate", {
    expression: "document.body ? document.body.innerText : ''",
    returnByValue: true,
  });
  return res.result.result.value || "";
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
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 94, y: 610, button: "left", clickCount: 1 }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 94, y: 610, button: "left", clickCount: 1 }).catch(() => {});
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
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: false }, 120000);
  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.writeFileSync(`${OUT_DIR}/${filename}`, Buffer.from(shot.result.data, "base64"));
  console.log(`${OUT_DIR}/${filename}`);
}

async function main() {
  fs.mkdirSync(OUT_DIR, { recursive: true });
  const target = await getCloudShellPage();
  if (!target) throw new Error("No Chrome page available on CDP port 9222");
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable");
  await send("Page.bringToFront").catch(() => {});
  await send("Emulation.setDeviceMetricsOverride", { width: 1280, height: 720, deviceScaleFactor: 1, mobile: false }).catch(() => {});
  await send("Page.navigate", { url: CLOUDSHELL_URL }, 60000);
  await wait(22000);
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Escape", code: "Escape", windowsVirtualKeyCode: 27 }).catch(() => {});
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Escape", code: "Escape", windowsVirtualKeyCode: 27 }).catch(() => {});

  let text = await bodyText(send).catch(() => "");
  if (/sign in|root user|iam user/i.test(text) && !/CloudShell|terminal|Actions/i.test(text)) {
    await screenshot(send, "00-cloudshell-login-required.png");
    throw new Error("AWS session is not logged in for CloudShell");
  }

  const labScript = fs.readFileSync(`${ROOT}/deploy-lab4.sh`, "utf8");
  const command = `cat > deploy-lab4.sh <<'EOF'\n${labScript}\nEOF\nchmod +x deploy-lab4.sh\n./deploy-lab4.sh 2>&1 | tee deploy-lab4.log\n`;
  await pasteCommand(send, command);

  for (let i = 0; i < 100; i++) {
    await wait(20000);
    text = await bodyText(send).catch(() => "");
    fs.writeFileSync(`${OUT_DIR}/01-cloudshell-deploy-text.txt`, text);
    if (text.includes("LAB4_DEPLOY_DONE LAB4-0705")) break;
    console.log(`waiting deploy ${i + 1}/100`);
  }

  await screenshot(send, "01-cloudshell-deploy-done.png").catch((err) => {
    console.log(`deploy screenshot skipped: ${err.message}`);
  });
  console.log(text.slice(-3500));
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
