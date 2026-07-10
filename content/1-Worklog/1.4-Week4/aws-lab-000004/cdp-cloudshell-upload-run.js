const fs = require("fs");
const http = require("http");

const ROOT = "D:/RoughLife GAME/RoughLife/aws-lab-000004";
const mode = process.argv[2] || "phase1";
const source = mode === "cleanup" ? "cleanup-lab4.sh" : mode === "phase1" ? "deploy-lab4-phase1.sh" : mode === "phase2" ? "deploy-lab4-phase2.sh" : mode === "iam" ? "deploy-lab4-iam.sh" : "deploy-lab4.sh";

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
  await wait(1000);
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 70, y: 237, button: "left", clickCount: 1 }).catch(() => {});
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 70, y: 237, button: "left", clickCount: 1 }).catch(() => {});

  const script = fs.readFileSync(`${ROOT}/${source}`, "utf8").replace(/\r\n/g, "\n");
  const chunks = [];
  let current = "";
  for (const line of script.split("\n")) {
    const next = `${line}\n`;
    if (current.length + next.length > 2200 && current.length > 0) {
      chunks.push(current);
      current = "";
    }
    current += next;
  }
  if (current.length > 0) chunks.push(current);
  await send("Input.insertText", { text: `: > ${source}\n` }, 30000);
  await wait(1000);
  for (let i = 0; i < chunks.length; i++) {
    const delimiter = `__LAB4_CHUNK_${i}_END__`;
    const text = `cat >> ${source} <<'${delimiter}'\n${chunks[i]}\n${delimiter}\n`;
    await send("Input.insertText", { text }, 60000);
    await wait(1200);
    console.log(`uploaded chunk ${i + 1}/${chunks.length}`);
  }
  await send("Input.insertText", { text: `chmod +x ${source}\n./${source} 2>&1 | tee ${mode}-lab4.log\n` }, 30000);
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
