const fs = require("fs");
const http = require("http");

const OUT_DIR = "D:/RoughLife GAME/RoughLife/aws-lab-000005/screenshots-ui";
const REGION = "ap-southeast-1";
const PREFIX = "RDS5-07031049";
const EC2 = "i-008133399ef9484c3";
const VPC = "vpc-07d24155ff42a94ee";
const DB = "rds5-07031049-mysql";
const RESTORE_DB = "rds5-07031049-mysql-restore";
const SNAPSHOT = "rds5-07031049-snapshot";

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

async function getPage() {
  const targets = await getJson("http://127.0.0.1:9222/json/list");
  return targets.find((p) => p.type === "page" && p.url.includes("console.aws.amazon.com")) || targets.find((p) => p.type === "page");
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
  function send(method, params = {}, timeoutMs = 45000) {
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

async function screenshot(send, filename) {
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: true }, 60000);
  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.writeFileSync(`${OUT_DIR}/${filename}`, Buffer.from(shot.result.data, "base64"));
  console.log(`${OUT_DIR}/${filename}`);
}

async function text(send) {
  const res = await send("Runtime.evaluate", {
    expression: "document.body ? document.body.innerText : ''",
    returnByValue: true,
  });
  return res.result.result.value || "";
}

async function typeCommand(send, command) {
  await send("Input.dispatchMouseEvent", { type: "mousePressed", x: 650, y: 610, button: "left", clickCount: 1 });
  await send("Input.dispatchMouseEvent", { type: "mouseReleased", x: 650, y: 610, button: "left", clickCount: 1 });
  await wait(500);
  await send("Input.insertText", { text: command });
  await send("Input.dispatchKeyEvent", { type: "keyDown", key: "Enter", code: "Enter", windowsVirtualKeyCode: 13 });
  await send("Input.dispatchKeyEvent", { type: "keyUp", key: "Enter", code: "Enter", windowsVirtualKeyCode: 13 });
}

async function main() {
  const target = await getPage();
  if (!target) throw new Error("No Chrome page on CDP port 9222");
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable");
  await send("Emulation.setDeviceMetricsOverride", { width: 1280, height: 720, deviceScaleFactor: 1, mobile: false });
  await send("Page.navigate", { url: `https://${REGION}.console.aws.amazon.com/cloudshell/home?region=${REGION}` }, 60000);
  await wait(18000);
  await send("Runtime.evaluate", {
    expression: "document.querySelector('[aria-label=\"Close welcome modal\"]')?.click(); document.querySelector('button[type=\"submit\"]')?.innerText === 'Close' && document.querySelector('button[type=\"submit\"]')?.click();",
  }).catch(() => {});
  await wait(1000);

  await typeCommand(send, `./cleanup-rds-lab5.sh 2>&1 | tee cleanup-rds-lab5-ui-final.log`);
  await wait(3000);
  await screenshot(send, "13-cleanup-started.png");

  let body = "";
  for (let i = 0; i < 14; i++) {
    await wait(60000);
    body = await text(send).catch(() => "");
    if (body.includes(`CLEANUP_COMPLETE ${PREFIX}`)) break;
  }
  await screenshot(send, "14-cleanup-complete.png");

  await typeCommand(
    send,
    `echo FINAL_RECHECK_${PREFIX}; aws ec2 describe-instances --region ${REGION} --instance-ids ${EC2} --query 'Reservations[0].Instances[0].State.Name' --output text 2>/dev/null || true; aws rds describe-db-instances --region ${REGION} --db-instance-identifier ${DB} >/dev/null 2>&1 || echo original-db-deleted; aws rds describe-db-instances --region ${REGION} --db-instance-identifier ${RESTORE_DB} >/dev/null 2>&1 || echo restore-db-deleted; aws rds describe-db-snapshots --region ${REGION} --db-snapshot-identifier ${SNAPSHOT} >/dev/null 2>&1 || echo snapshot-deleted; aws ec2 describe-vpcs --region ${REGION} --vpc-ids ${VPC} >/dev/null 2>&1 || echo vpc-deleted`
  );
  await wait(8000);
  await screenshot(send, "15-cleanup-final-recheck.png");
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
