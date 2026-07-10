const fs = require("fs");
const http = require("http");

const OUT_DIR = "D:/RoughLife GAME/RoughLife/aws-lab-000007/screenshots-ui";
const BUDGETS_URL = "https://us-east-1.console.aws.amazon.com/costmanagement/home#/budgets";
const NAMES = [
  ["02-budget-list-created.png", BUDGETS_URL, "Budgets list with all LAB7 budgets"],
  ["03-template-cost-budget.png", `${BUDGETS_URL}/details?name=LAB7-0704-TemplateCost`, "Template monthly cost budget"],
  ["04-cost-budget.png", `${BUDGETS_URL}/details?name=LAB7-0704-CostMonthly`, "Customized cost budget"],
  ["05-usage-budget.png", `${BUDGETS_URL}/details?name=LAB7-0704-UsageEC2Hours`, "Usage budget"],
  ["06-ri-budget.png", `${BUDGETS_URL}/details?name=LAB7-0704-RIUtilization`, "RI utilization budget"],
  ["07-savings-plans-budget.png", `${BUDGETS_URL}/details?name=LAB7-0704-SPUtilization`, "Savings Plans utilization budget"],
];

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

async function getAwsPage() {
  const targets = await getJson("http://127.0.0.1:9222/json/list");
  return targets.find((p) => p.type === "page" && p.url.includes("billing/home")) ||
    targets.find((p) => p.type === "page" && p.url.includes("console.aws.amazon.com") && !p.url.includes("cloudshell/home")) ||
    targets.find((p) => p.type === "page");
}

async function screenshot(send, filename) {
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: true }, 120000);
  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.writeFileSync(`${OUT_DIR}/${filename}`, Buffer.from(shot.result.data, "base64"));
  console.log(`${OUT_DIR}/${filename}`);
}

async function pageText(send) {
  const res = await send("Runtime.evaluate", {
    expression: "document.body ? document.body.innerText : ''",
    returnByValue: true,
  });
  return res.result.result.value || "";
}

async function main() {
  const target = await getAwsPage();
  if (!target) throw new Error("No AWS console page on CDP port 9222");
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable");
  await send("Page.bringToFront").catch(() => {});
  await send("Emulation.setDeviceMetricsOverride", { width: 1280, height: 720, deviceScaleFactor: 1, mobile: false }).catch(() => {});

  for (const [file, url, note] of NAMES) {
    await send("Page.navigate", { url }, 60000);
    await wait(18000);
    await send("Runtime.evaluate", {
      expression: `(() => {
        const input = [...document.querySelectorAll('input')].find((el) => /filter|search/i.test(el.placeholder || el.getAttribute('aria-label') || ''));
        if (input && location.hash.endsWith('/budgets')) {
          input.focus();
          input.value = 'LAB7-0704';
          input.dispatchEvent(new Event('input', {bubbles:true}));
        }
      })()`,
    }).catch(() => {});
    await wait(3000);
    const text = await pageText(send);
    fs.writeFileSync(`${OUT_DIR}/${file}.txt`, `${note}\n${url}\n\n${text}`);
    await screenshot(send, file);
  }
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
