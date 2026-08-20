#!/usr/bin/env node
/**
 * sync-fitness-dashboard.js
 *
 * Keeps the embedded fitnessData object inside fitness-dashboard.html in sync
 * with fitness-data.json. Run this after editing fitness-data.json so the dashboard
 * works correctly when opened directly as a local file.
 */

const fs = require('fs');
const path = require('path');

const baseDir = __dirname;
const htmlPath = path.join(baseDir, 'fitness-dashboard.html');
const jsonPath = path.join(baseDir, 'fitness-data.json');
const backupPath = path.join(baseDir, 'fitness-dashboard.html.backup');

const startMarker = 'const fitnessData = {';
const endMarker = 'let data = [];';

if (!fs.existsSync(htmlPath)) {
  console.error(`HTML file not found: ${htmlPath}`);
  process.exit(1);
}
if (!fs.existsSync(jsonPath)) {
  console.error(`JSON file not found: ${jsonPath}`);
  process.exit(1);
}

let html = fs.readFileSync(htmlPath, 'utf8');
const jsonObj = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));

const startIdx = html.indexOf(startMarker);
const endIdx = html.indexOf(endMarker);

if (startIdx === -1 || endIdx === -1 || endIdx <= startIdx) {
  console.error('Could not locate fitnessData block in HTML.');
  process.exit(1);
}

// Build replacement block; keep indentation style consistent with the HTML
const jsonString = JSON.stringify(jsonObj, null, 2);
const replacement = `${startMarker}\n${jsonString.slice(1, -1)}\n};\n`;

const before = html.slice(0, startIdx);
const after = html.slice(endIdx);
const newHtml = before + replacement + after;

// Keep a simple rotating backup
fs.writeFileSync(backupPath, html, 'utf8');
fs.writeFileSync(htmlPath, newHtml, 'utf8');

console.log(`Synced ${jsonPath} -> embedded fitnessData in ${htmlPath}`);
console.log(`Backup saved to ${backupPath}`);
