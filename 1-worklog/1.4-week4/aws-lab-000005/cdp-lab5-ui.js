const fs = require("fs");
const http = require("http");

const OUT_DIR = "D:/RoughLife GAME/RoughLife/aws-lab-000005/screenshots-ui";
const REGION = "ap-southeast-1";
const IDS = {
  prefix: "RDS5-07031049",
  vpc: "vpc-07d24155ff42a94ee",
  publicSubnet: "subnet-0539a77595d2636d7",
  dbSubnet1: "subnet-0b22bf4a2d3adb729",
  dbSubnet2: "subnet-06301219c191b87e3",
  ec2Sg: "sg-0a46cfe06bd7cc67e",
  rdsSg: "sg-0d259a219d276ae53",
  dbSubnetGroup: "rds5-07031049-db-subnet-group",
  ec2: "i-008133399ef9484c3",
  db: "rds5-07031049-mysql",
  restoreDb: "rds5-07031049-mysql-restore",
  snapshot: "rds5-07031049-snapshot",
  app: "http://47.129.8.221:5000",
};

const pages = [
  ["01-vpc-details.png", `https://${REGION}.console.aws.amazon.com/vpcconsole/home?region=${REGION}#VpcDetails:VpcId=${IDS.vpc}`],
  ["02-public-subnet.png", `https://${REGION}.console.aws.amazon.com/vpcconsole/home?region=${REGION}#SubnetDetails:subnetId=${IDS.publicSubnet}`],
  ["03-db-subnet-az1.png", `https://${REGION}.console.aws.amazon.com/vpcconsole/home?region=${REGION}#SubnetDetails:subnetId=${IDS.dbSubnet1}`],
  ["04-ec2-security-group.png", `https://${REGION}.console.aws.amazon.com/ec2/home?region=${REGION}#SecurityGroup:groupId=${IDS.ec2Sg}`],
  ["05-rds-security-group.png", `https://${REGION}.console.aws.amazon.com/ec2/home?region=${REGION}#SecurityGroup:groupId=${IDS.rdsSg}`],
  ["06-db-subnet-group.png", `https://${REGION}.console.aws.amazon.com/rds/home?region=${REGION}#db-subnet-group-details:name=${IDS.dbSubnetGroup}`],
  ["07-ec2-instance.png", `https://${REGION}.console.aws.amazon.com/ec2/home?region=${REGION}#InstanceDetails:instanceId=${IDS.ec2}`],
  ["08-rds-databases-list.png", `https://${REGION}.console.aws.amazon.com/rds/home?region=${REGION}#databases:`],
  ["09-rds-original-detail.png", `https://${REGION}.console.aws.amazon.com/rds/home?region=${REGION}#database:id=${IDS.db};is-cluster=false`],
  ["10-app-page.png", IDS.app],
  ["11-rds-snapshot.png", `https://${REGION}.console.aws.amazon.com/rds/home?region=${REGION}#snapshot:id=${IDS.snapshot};type=manual`],
  ["12-rds-restore-detail.png", `https://${REGION}.console.aws.amazon.com/rds/home?region=${REGION}#database:id=${IDS.restoreDb};is-cluster=false`],
];

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

async function save(send, filename) {
  const shot = await send("Page.captureScreenshot", { format: "png", fromSurface: true }, 60000);
  fs.mkdirSync(OUT_DIR, { recursive: true });
  fs.writeFileSync(`${OUT_DIR}/${filename}`, Buffer.from(shot.result.data, "base64"));
  console.log(`${OUT_DIR}/${filename}`);
}

async function nav(send, url, waitMs) {
  await send("Page.navigate", { url }, 60000);
  await wait(waitMs);
}

async function main() {
  const target = await getPage();
  if (!target) throw new Error("No Chrome page on CDP port 9222");
  const { ws, send } = await connect(target.webSocketDebuggerUrl);
  await send("Page.enable");
  await send("Runtime.enable");
  await send("Emulation.setDeviceMetricsOverride", { width: 1280, height: 720, deviceScaleFactor: 1, mobile: false });

  for (const [filename, url] of pages) {
    const waitMs = url.includes("rds/home") ? 14000 : url.includes("ec2/home") || url.includes("vpcconsole") ? 11000 : 5000;
    await nav(send, url, waitMs);
    await save(send, filename);
  }
  ws.close();
}

main().catch((err) => {
  console.error(err.stack || err.message);
  process.exit(1);
});
