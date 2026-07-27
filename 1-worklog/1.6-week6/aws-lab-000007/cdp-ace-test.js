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
  const res = await send("Runtime.evaluate", {
    expression: `(() => {
      const term = document.querySelector('.ace_editor.terminal.ace_focus') || [...document.querySelectorAll('.ace_editor.terminal')].at(-1);
      if (!term || !window.ace) return {ok:false, reason:'no term or ace'};
      const ed = window.ace.edit(term);
      ed.focus();
      ed.insert('echo LAB7_FOCUS_TEST\\\\n');
      return {ok:true, text: document.body.innerText.slice(-500)};
    })()`,
    returnByValue: true,
  });
  console.log(JSON.stringify(res.result.result.value, null, 2));
  await new Promise((resolve) => setTimeout(resolve, 3000));
  const text = await send("Runtime.evaluate", { expression: "document.body.innerText.slice(-1000)", returnByValue: true });
  console.log(text.result.result.value);
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
