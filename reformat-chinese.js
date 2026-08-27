#!/usr/bin/env node
/**
 * Reformat Chinese vocab Anki import file:
 * OLD: Front="你好 (nǐ hǎo)", Back="Hello"
 * NEW: Front="你好", Back="nǐ hǎo — Hello"
 *
 * Usage: node reformat-chinese.js input.txt output.txt
 */

const fs = require('fs');

const [,, inputFile, outputFile] = process.argv;
if (!inputFile || !outputFile) {
  console.error('Usage: node reformat-chinese.js input.txt output.txt');
  process.exit(1);
}

const content = fs.readFileSync(inputFile, 'utf-8');
const lines = content.split('\n');

const output = [];
let entryCount = 0;

for (const line of lines) {
  // Pass through header lines unchanged
  if (line.startsWith('#')) {
    output.push(line);
    continue;
  }

  // Skip empty lines
  if (!line.trim()) {
    output.push(line);
    continue;
  }

  // Parse tab-separated: Front\tBack\tTags
  const parts = line.split('\t');
  if (parts.length < 2) {
    console.warn('Skipping malformed line:', line);
    output.push(line);
    continue;
  }

  const [front, back, ...rest] = parts;
  const tags = rest.join('\t');

  // Extract Chinese and pinyin from front: "你好 (nǐ hǎo)"
  const match = front.match(/^(.+?)\s*\(([^)]+)\)\s*$/);
  if (!match) {
    console.warn('Could not parse front:', front);
    output.push(line);
    continue;
  }

  const chinese = match[1].trim();
  const pinyin = match[2].trim();

  // New format: Front=Chinese only, Back="pinyin — English"
  const newFront = chinese;
  const newBack = `${pinyin} — ${back}`;

  const newLine = tags
    ? `${newFront}\t${newBack}\t${tags}`
    : `${newFront}\t${newBack}`;

  output.push(newLine);
  entryCount++;
}

fs.writeFileSync(outputFile, output.join('\n'), 'utf-8');
console.log(`Reformatted ${entryCount} entries.`);
console.log(`Output written to: ${outputFile}`);
