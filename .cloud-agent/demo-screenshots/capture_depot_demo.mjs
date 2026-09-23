import puppeteer from "puppeteer";
import { mkdirSync } from "fs";
import { join } from "path";

const outDir = process.env.CURSOR_ARTIFACTS_DIR || "/opt/cursor/artifacts";
mkdirSync(outDir, { recursive: true });

const base = "http://127.0.0.1:3000";

const browser = await puppeteer.launch({
  headless: true,
  args: ["--no-sandbox", "--disable-setuid-sandbox", "--window-size=1280,900"],
});
const page = await browser.newPage();
await page.setViewport({ width: 1280, height: 900 });

async function shot(name) {
  await page.screenshot({ path: join(outDir, name), fullPage: true });
  console.log("saved", name);
}

await page.goto(`${base}/`, { waitUntil: "networkidle2", timeout: 60000 });
await shot("screenshot_storefront.png");

await page.goto(`${base}/login?locale=en`, { waitUntil: "networkidle2" });
await shot("screenshot_admin_login.png");

await page.goto(`${base}/`, { waitUntil: "networkidle2" });
await page.click('form.button_to button[type="submit"]');
await new Promise((r) => setTimeout(r, 1500));
await shot("screenshot_cart_after_add.png");

await page.goto(`${base}/login?locale=en`, { waitUntil: "networkidle2" });
await Promise.all([
  page.waitForNavigation({ waitUntil: "networkidle2" }),
  page.evaluate(() => {
    const form = document.querySelector(".depot_form form");
    form.querySelector('input[name="name"]').value = "dave";
    form.querySelector('input[name="password"]').value = "secret";
    form.submit();
  }),
]);
await page.waitForSelector("#main h1", { timeout: 15000 });
const title = await page.$eval("#main h1", (el) => el.textContent);
if (!title.includes("Welcome")) {
  throw new Error(`Expected admin dashboard, got: ${title}`);
}
await shot("screenshot_admin_dashboard.png");

await page.goto(`${base}/orders?locale=en`, { waitUntil: "networkidle2" });
await shot("screenshot_admin_orders.png");

await page.goto(`${base}/orders/new?locale=en`, { waitUntil: "networkidle2" });
await shot("screenshot_checkout_form.png");

await browser.close();
console.log("done");
