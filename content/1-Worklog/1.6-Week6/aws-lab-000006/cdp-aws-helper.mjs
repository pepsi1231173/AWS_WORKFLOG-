import { writeFile, mkdir } from "node:fs/promises";
import path from "node:path";

const CDP = "http://127.0.0.1:9222";

export async function newTab(url = "about:blank") {
  let res = await fetch(`${CDP}/json/new?${encodeURIComponent(url)}`, { method: "PUT" });
  if (!res.ok) {
    res = await fetch(`${CDP}/json/new?${encodeURIComponent(url)}`);
  }
  if (!res.ok) throw new Error(`Failed to open tab: ${res.status} ${await res.text()}`);
  const info = await res.json();
  return connect(info.webSocketDebuggerUrl);
}

export async function listTabs() {
  const res = await fetch(`${CDP}/json`);
  if (!res.ok) throw new Error(`Failed to list tabs: ${res.status}`);
  return res.json();
}

export async function connect(wsUrl) {
  const ws = new WebSocket(wsUrl);
  await new Promise((resolve, reject) => {
    ws.addEventListener("open", resolve, { once: true });
    ws.addEventListener("error", reject, { once: true });
  });
  let nextId = 1;
  const pending = new Map();
  ws.addEventListener("message", (event) => {
    const msg = JSON.parse(event.data);
    if (msg.id && pending.has(msg.id)) {
      const { resolve, reject } = pending.get(msg.id);
      pending.delete(msg.id);
      if (msg.error) reject(new Error(JSON.stringify(msg.error)));
      else resolve(msg.result);
    }
  });
  async function send(method, params = {}) {
    const id = nextId++;
    ws.send(JSON.stringify({ id, method, params }));
    return new Promise((resolve, reject) => pending.set(id, { resolve, reject }));
  }
  function close() {
    try {
      ws.close();
    } catch {}
  }
  return { ws, send, close };
}

export async function setupPage(client, width = 2048, height = 1152) {
  await client.send("Page.enable");
  await client.send("Runtime.enable");
  await client.send("DOM.enable");
  await client.send("Input.setIgnoreInputEvents", { ignore: false }).catch(() => {});
  await client.send("Emulation.setDeviceMetricsOverride", {
    width,
    height,
    deviceScaleFactor: 1,
    mobile: false,
  });
}

export async function navigate(client, url, waitMs = 8000) {
  await client.send("Page.navigate", { url });
  await sleep(waitMs);
}

export async function screenshot(client, filePath) {
  await mkdir(path.dirname(filePath), { recursive: true });
  const result = await client.send("Page.captureScreenshot", {
    format: "png",
    fromSurface: true,
    captureBeyondViewport: false,
  });
  await writeFile(filePath, Buffer.from(result.data, "base64"));
}

export async function text(client) {
  const result = await client.send("Runtime.evaluate", {
    expression: "document.body ? document.body.innerText : ''",
    returnByValue: true,
  });
  return result.result.value ?? "";
}

export async function click(client, x, y) {
  await client.send("Input.dispatchMouseEvent", { type: "mousePressed", x, y, button: "left", clickCount: 1 });
  await client.send("Input.dispatchMouseEvent", { type: "mouseReleased", x, y, button: "left", clickCount: 1 });
}

export async function press(client, key) {
  await client.send("Input.dispatchKeyEvent", { type: "keyDown", key });
  await client.send("Input.dispatchKeyEvent", { type: "keyUp", key });
}

export async function insertText(client, value) {
  await client.send("Input.insertText", { text: value });
}

export function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
