---
name: create-tasks
description: Decomposes a technical design doc into granular, traceable development tasks. Use when the user invokes /create-tasks, asks for an implementation plan, or wants an append-only task list for a new feature.
---

# Create Tasks

## Purpose

Act as a senior technical lead.

Convert an implementation-level design document into an atomic, executable
task list that is easy to track and safe to execute incrementally.

This is a user-level skill and must stay project-agnostic.

## Trigger

Activate when the user runs:

- `/create-tasks [feature name, design excerpt, or selected code]`

Also activate when the user asks for:

- "break this design into tasks"
- "create an implementation checklist"
- "generate tasks.md"

## Context Priority

When generating tasks, collect and prioritize context in this order:

1. `docs/en/design.md` (if present)
2. `docs/en/requirements.md` (if present)
3. `docs/en/tasks.md` (if present)
4. Currently opened files in the editor
5. User-selected code snippets
6. `README.md` in the current project

If canonical docs do not exist, scan for legacy filenames (best-effort):

- Design: `design.md`, `spec.md`
- Requirements: `requirements.md`, `PRD.md`
- Tasks: `tasks.md`

## Canonical Docs Paths

Default output targets (English):

- Requirements/PRD: `docs/en/requirements.md`
- Design/Spec: `docs/en/design.md`
- Tasks: `docs/en/tasks.md`

If legacy docs exist but canonical docs do not, treat legacy docs as inputs,
but write outputs to canonical paths to normalize the workflow.

## Interaction Workflow

### Step 1: Detect Starting Point

Classify input into one of three modes:

- **Mode A: Greenfield** (no tasks exist; first implementation plan)
- **Mode B: Brownfield** (tasks exist; append tasks for a new feature/change)
- **Mode C: Incomplete context** (design is missing or unclear)

### Step 2: Clarify If Needed (Minimal)

Ask only what is required to produce actionable tasks:

- What is the feature name for the new tasks section?
- Are there any milestones or delivery phases?
- Are there constraints on tech stack, rollout, or testing depth?

### Step 3: Append-Only Update Logic

If an existing `docs/en/tasks.md` (or legacy tasks file) exists:

- Do not rewrite or delete existing tasks.
- Append a new section at the end:
  - `## [Feature Name] Implementation`
- Keep task IDs and checkboxes consistent.
- Preserve historical context and progress.

If no tasks doc exists:

- Generate a full initial `docs/en/tasks.md`.

### Step 4: Output

By default, write tasks to `docs/en/tasks.md`.

If the user requests a different location, follow the user, but keep the
append-only behavior and structure.

## Output Requirements

Always output tasks in Markdown using checkboxes.
Do not omit sections; use "TBD" when data is missing.

```markdown
## Overview
- Source design: (link or name)
- Scope: (feature / change)
- Assumptions: (if any)

## Tasks
### 1) Infrastructure & Data Model
- [ ] T-1:
- [ ] T-2:

### 2) Backend Logic & APIs
- [ ] T-3:
- [ ] T-4:

### 3) Frontend & UI Components
- [ ] T-5:
- [ ] T-6:

### 4) Testing & Validation
- [ ] T-7:
- [ ] T-8:
```

## Task Writing Rules

- Each task must be small enough for one focused coding session.
- Each task must be independently checkable (clear definition of done).
- Prefer verb-first tasks (imperative mood).
- Include a short traceability hint for every task, referencing the design:
  - Example: `(Design §4 Interfaces)` or `(Design §5 Processing Logic)`
- When available, also reference PRD requirement IDs:
  - Example: `(FR-3, AC-7)`
- Do not include file paths, function names, or command-line snippets unless
  the user explicitly requested implementation details in tasks.

## Quality Gate (Before Final Output)

- No task is ambiguous or multi-day sized.
- The sequence is coherent (data/contracts before dependent logic).
- There is at least one testing/verification task per major behavior group.
- Every major design section is covered by at least one task.

