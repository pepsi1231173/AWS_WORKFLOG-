const fs = require("fs");
const http = require("http");

const ROOT = "D:/RoughLife GAME/RoughLife/aws-lab-000004";
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

async function main() {
  const mode = process.argv[2] || "deploy";
  const source = mode === "cleanup" ? "cleanup-lab4.sh" : mode === "phase1" ? "deploy-lab4-phase1.sh" : "deploy-lab4.sh";
  const script = fs.readFileSync(`${ROOT}/${source}`, "utf8");
  const delimiter = `__LAB4_${mode.toUpperCase()}_PAYLOAD_END__`;
  const command = `cat > ${source} <<'${delimiter}'\n${script}\n${delimiter}\nchmod +x ${source}\n./${source} 2>&1 | tee ${mode}-lab4.log\n`;
  const targets = await getJson("http://127.0.0.1:9222/json/list");
  const target = targets.find((p) => p.type === "page" && p.url.includes("cloudshell/home")) ||
    targets.find((p) => p.type === "page" && p.url.includes("console.aws.amazon.com"));
  if (!target) throw new Error("No AWS console page on CDP port 9222");
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Page.bringToFront").catch(() => {});
  await send("Emulation.setDeviceMetricsOverride", { width: 2048, height: 1152, deviceScaleFactor: 1, mobile: false }).catch(() => {});
  await send("Page.navigate", { url: CLOUDSHELL_URL }, 60000).catch(() => {});
  await wait(15000);
  await send("Page.bringToFront").catch(() => {});
  await send("Runtime.enable").catch(() => {});
  await send("Runtime.evaluate", {
    expression: `(() => {
      const els = [...document.querySelectorAll('button, [role="button"]')];
      const close = els.find((el) => /^(Close|Got it)$/i.test((el.innerText || el.getAttribute('aria-label') || '').trim()));
      if (close) close.click();
      const x = [...document.querySelectorAll('[aria-label], button')].find((el) => /close/i.test(el.getAttribute('aria-label') || ''));
      if (x) x.click();
      return Boolean(close || x);
    })()`,
    returnByValue: true,
  }, 10000).catch(() => {});
  await wait(1000);
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Escape", code: "Escape", windowsVirtualKeyCode: 27 }).catch(() => {});
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Escape", code: "Escape", windowsVirtualKeyCode: 27 }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 1628, y: 253, button: "left", clickCount: 1 }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 1628, y: 253, button: "left", clickCount: 1 }).catch(() => {});
  await wait(500);
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 1584, y: 900, button: "left", clickCount: 1 }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 1584, y: 900, button: "left", clickCount: 1 }).catch(() => {});
  await wait(1000);
  await send("Runtime.evaluate", {
    expression: `(() => {
      const ta = document.querySelector('.ace_editor.terminal textarea, textarea');
      if (ta) ta.focus();
      return Boolean(ta);
    })()`,
    returnByValue: true,
  }, 10000).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 62, y: 238, button: "left", clickCount: 1 }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 62, y: 238, button: "left", clickCount: 1 }).catch(() => {});
  await wait(500);
  await send("Input.insertText", { text: command }, 240000);
  await wait(1000);
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Enter", code: "Enter", windowsVirtualKeyCode: 13 }).catch(() => {});
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Enter", code: "Enter", windowsVirtualKeyCode: 13 }).catch(() => {});
  await wait(1000);
  ws.close();
  console.log(`inserted ${mode} command chars=${command.length}`);
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
