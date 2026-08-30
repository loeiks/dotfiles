#!/usr/bin/env bun

import { join, dirname } from "path";
import { fileURLToPath } from "url";
import { intro, outro, multiselect, isCancel, cancel } from "@clack/prompts";

const ROOT = dirname(fileURLToPath(import.meta.url));

function runScript(relativePath, options = []) {
  const script = join(ROOT, relativePath);
  const result = Bun.spawnSync(["bash", script, ...options], {
    stdio: ["inherit", "inherit", "inherit"],
  });
  if (result.exitCode !== 0) {
    console.error(`✗ ${relativePath} exited with code ${result.exitCode}`);
  }
}

const steps = [
  {
    label: "Install Docker",
    hint: "Docker Engine on Linux, or a Docker Desktop pointer on macOS.",
    run: () => runScript("scripts/install-docker.sh"),
  },
  {
    label: "Install bun globals",
    hint: "Global packages via `bun add -g` from scripts/bun-globals.txt.",
    run: () => runScript("scripts/install-bun-globals.sh"),
  },
  {
    label: "Make zsh default shell",
    hint: "If zsh is already installed, make it default.",
    run: () => runScript("scripts/prep/default-zsh.sh"),
  },
  {
    label: "Generate SSH key",
    hint: "Ed25519 key for GitHub etc., added to ssh-agent.",
    run: () => runScript("scripts/setup-ssh.sh"),
  },
];

async function main() {
  intro("dotfiles init");

  const selected = await multiselect({
    message: "Select steps to run",
    options: steps.map((step) => ({ value: step, label: step.label, hint: step.hint })),
    initialValues: steps.filter((step) => step.default),
  });

  if (isCancel(selected)) {
    cancel("Cancelled.");
    process.exit(0);
  }

  for (const step of selected) {
    console.log(`\n--- Running: ${step.label} ---`);
    step.run();
  }

  outro("Done.");
}

main();
