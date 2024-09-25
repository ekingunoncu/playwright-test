import { PlaywrightTestConfig } from "@playwright/test";

const config: PlaywrightTestConfig = {
  testDir: "./test",
  use: {
    headless: true,
  },
};

export default config;
