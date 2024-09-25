import { test, expect } from "@playwright/test";

test("basic test", async ({ page }) => {
  await page.goto("https://example.com/");
  const element = await page.$("text=Example Domain");
  // wait 10 seconds
  await page.waitForTimeout(10000);
  expect(element).toBeTruthy();
});
