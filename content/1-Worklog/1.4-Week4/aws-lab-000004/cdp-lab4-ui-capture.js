const fs = require("fs");
const http = require("http");

const ROOT = "D:/RoughLife GAME/RoughLife/aws-lab-000004";
const OUT_DIR = `${ROOT}/screenshots-ui`;
const DEPLOY_TEXT = `${OUT_DIR}/01-cloudshell-deploy-text.txt`;
const PREFIX = "LAB4-0705";
const REGION = "ap-southeast-1";

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
  return targets.find((p) => p.type === "page" && p.url === "about:blank") ||
    targets.find((p) => p.type === "page" && p.url.includes("console.aws.amazon.com") && !p.url.includes("cloudshell/home")) ||
    targets.find((p) => p.type === "page");
}

async function pageText(send) {
  const res = await send("Runtime.evaluate", {
    expression: "document.body ? document.body.innerText : ''",
    returnByValue: true,
  });
  return res.result.result.value || "";
}

async function screenshot(send, filename) {
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: false }, 120000);
  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.writeFileSync(`${OUT_DIR}/${filename}`, Buffer.from(shot.result.data, "base64"));
  console.log(`${OUT_DIR}/${filename}`);
}

function valueFromDeploy(name) {
  if (!fs.existsSync(DEPLOY_TEXT)) return "";
  const text = fs.readFileSync(DEPLOY_TEXT, "utf8");
  const match = text.match(new RegExp(`${name}=([^\\s]+)`));
  return match ? match[1] : "";
}

async function capture(send, filename, url, note, waitMs = 18000) {
  await send("Page.bringToFront").catch(() => {});
  await send("Page.navigate", { url }, 60000);
  await wait(waitMs);
  await send("Page.bringToFront").catch(() => {});
  await send("Runtime.evaluate", {
    expression: `(() => {
      const buttons = [...document.querySelectorAll('button')];
      for (const text of ['Refresh', 'Close', 'Cancel']) {
        const btn = buttons.find((el) => (el.innerText || el.getAttribute('aria-label') || '').trim() === text);
        if (btn && text === 'Close') btn.click();
      }
    })()`,
  }).catch(() => {});
  const text = await pageText(send).catch(() => "");
  fs.writeFileSync(`${OUT_DIR}/${filename}.txt`, `${note}\n${url}\n\n${text}`);
  await screenshot(send, filename);
}

async function main() {
  fs.mkdirSync(OUT_DIR, { recursive: true });
  const linuxApp = valueFromDeploy("LINUX_APP_URL");
  const linuxNode = valueFromDeploy("LINUX_NODE_URL");
  const windowsApp = valueFromDeploy("WINDOWS_APP_URL");
  const amiApp = valueFromDeploy("AMI_APP_URL");

  const pages = [
    ["02-vpc-list.png", `https://${REGION}.console.aws.amazon.com/vpcconsole/home?region=${REGION}#vpcs:search=${PREFIX}`, "2.1/2.2 VPC Linux and Windows created with LAB4 prefix"],
    ["03-subnets.png", `https://${REGION}.console.aws.amazon.com/vpcconsole/home?region=${REGION}#subnets:search=${PREFIX}`, "2.1/2.2 Public and private subnets for both VPCs"],
    ["04-security-groups.png", `https://${REGION}.console.aws.amazon.com/vpcconsole/home?region=${REGION}#SecurityGroups:search=${PREFIX}`, "2.3/2.4 Linux and Windows security groups"],
    ["05-ec2-instances.png", `https://${REGION}.console.aws.amazon.com/ec2/home?region=${REGION}#Instances:search=${PREFIX}`, "3/4/5 EC2 instances for Windows, Linux, and custom AMI workflow", 22000],
    ["06-ebs-volumes.png", `https://${REGION}.console.aws.amazon.com/ec2/home?region=${REGION}#Volumes:search=${PREFIX}`, "5.1 EBS root volumes for lab instances"],
    ["07-ebs-snapshots.png", `https://${REGION}.console.aws.amazon.com/ec2/home?region=${REGION}#Snapshots:visibility=owned-by-me;search=${PREFIX}`, "5.2 EBS snapshot created from Linux root volume"],
    ["08-custom-ami.png", `https://${REGION}.console.aws.amazon.com/ec2/home?region=${REGION}#Images:visibility=owned-by-me;search=${PREFIX}`, "5.3 Custom AMI created from Linux instance"],
    ["09-iam-policies.png", `https://us-east-1.console.aws.amazon.com/iam/home#/policies?search=${PREFIX}`, "8.1-8.6 IAM governance policies for region, family, size, EBS, IP, and time controls", 22000],
  ];

  if (linuxApp) pages.splice(5, 0, ["10-linux-app.png", linuxApp, "6.1/6.3 AWS User Management application on Amazon Linux", 25000]);
  if (linuxNode) pages.splice(6, 0, ["11-linux-node-check.png", linuxNode, "6.2 Node.js runtime check on Amazon Linux", 12000]);
  if (windowsApp) pages.splice(7, 0, ["12-windows-app.png", windowsApp, "7 Windows web application page on EC2 Windows/IIS", 30000]);
  if (amiApp) pages.splice(8, 0, ["13-custom-ami-app.png", amiApp, "5.4 Instance launched from custom AMI serving the copied Linux app", 20000]);

  const target = await getAwsPage();
  if (!target) throw new Error("No Chrome page available on CDP port 9222");
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable");
  await send("Page.bringToFront").catch(() => {});
  await send("Emulation.setDeviceMetricsOverride", { width: 1280, height: 720, deviceScaleFactor: 1, mobile: false }).catch(() => {});

  for (const [file, url, note, waitMs] of pages) {
    await capture(send, file, url, note, waitMs || 18000);
  }
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
