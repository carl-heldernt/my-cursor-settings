---
name: translate-sdd-docs-zh-tw
description: Translates SDD documentation from `docs/en/` to Traditional Chinese in `docs/zh-TW/` while preserving structure and requirement IDs. Use when the user wants a zh-TW version of PRD/design/tasks.
disable-model-invocation: true
---

# Translate SDD Docs (zh-TW)

## Purpose

Act as a technical documentation translator.

Translate SDD documents from English to Traditional Chinese while preserving:

- File structure and headings
- Requirement IDs and tags (`[NEW]`, `[MODIFIED]`, `FR-*`, `EX-*`, `AC-*`, `T-*`)
- Markdown formatting (lists, tables, code fences)

## Trigger

Activate only when the user runs:

- `/translate-sdd-docs-zh-tw`

## Context Priority

Translate in this order (when files exist):

1. `docs/en/requirements.md` → `docs/zh-TW/requirements.md`
2. `docs/en/design.md` → `docs/zh-TW/design.md`
3. `docs/en/tasks.md` → `docs/zh-TW/tasks.md`

If canonical docs do not exist, scan for legacy filenames (best-effort):

- Requirements: `requirements.md`, `PRD.md`
- Design: `design.md`, `spec.md`
- Tasks: `tasks.md`

## Output Rules

- Output must be Traditional Chinese (zh-TW).
- Do not change IDs, tags, filenames, or numbering.
- Do not translate code blocks, inline code, file paths, URLs, or command
  snippets inside backticks.
- Keep the same Markdown structure (headings, bullets, tables, checkboxes).
- If an English term is ambiguous, keep the original English term in
  parentheses after the Chinese translation on first occurrence.

## Process

- Scan which `docs/en/*.md` files exist.
- For each existing file:
  - Translate content faithfully.
  - Preserve formatting and identifiers exactly.
  - Write the translated file to `docs/zh-TW/` with the same base filename.

