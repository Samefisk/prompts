#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import process from "node:process";

const root = path.resolve(import.meta.dirname, "..");
const jsonPath = path.join(root, "super.json");
const promptPath = path.join(root, "super-prompt.md");

const command = process.argv[2] ?? "check";

function readJson() {
  return JSON.parse(fs.readFileSync(jsonPath, "utf8"));
}

function writePromptToJson(prompt) {
  const raw = fs.readFileSync(jsonPath, "utf8");
  const pattern =
    /(\n\s*"prompt"\s*:\s*)"(?:\\.|[^"\\])*"(?=,\n\s*"promptExamples"\s*:)/s;
  const match = raw.match(pattern);

  if (!match) {
    throw new Error("Could not locate prompt field before promptExamples.");
  }

  const next = raw.replace(pattern, `${match[1]}${JSON.stringify(prompt)}`);
  JSON.parse(next);
  fs.writeFileSync(jsonPath, next);
}

function normalizeMarkdownPrompt(markdown) {
  return markdown.endsWith("\n") ? markdown.slice(0, -1) : markdown;
}

function exportPrompt() {
  const prompt = readJson().prompt;
  fs.writeFileSync(promptPath, `${prompt}\n`);
  console.log("Exported super.json prompt to super-prompt.md");
}

function importPrompt() {
  const prompt = normalizeMarkdownPrompt(fs.readFileSync(promptPath, "utf8"));
  writePromptToJson(prompt);
  console.log("Imported super-prompt.md into super.json");
}

function checkPrompt() {
  const prompt = readJson().prompt;
  const markdown = fs.readFileSync(promptPath, "utf8");

  if (prompt !== normalizeMarkdownPrompt(markdown)) {
    console.error("super.json prompt and super-prompt.md differ.");
    console.error("Run: node scripts/super-prompt.mjs export");
    process.exit(1);
  }

  console.log("super.json prompt and super-prompt.md are in sync");
}

switch (command) {
  case "export":
    exportPrompt();
    break;
  case "import":
    importPrompt();
    break;
  case "check":
    checkPrompt();
    break;
  default:
    console.error("Usage: node scripts/super-prompt.mjs [check|export|import]");
    process.exit(2);
}
