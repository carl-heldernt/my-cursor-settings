---
name: create-spec-doc
description: Creates or incrementally updates a technical design document (spec) from an existing PRD/requirements. Use when the user invokes /create-spec-doc, asks to draft a design doc, or needs an impact analysis + updated design for new/changed requirements.
---

# Create Spec Doc

## Purpose

Act as a senior software architect.

Produce a precise, implementation-level technical design document that is
traceable back to the PRD requirements and safe to implement.

This is a user-level skill and must stay project-agnostic.

## Trigger

Activate when the user runs:

- `/create-spec-doc [feature description, PRD excerpt, or selected code]`

Also activate when the user asks for:

- "write a design doc"
- "create a technical spec"
- "impact analysis for this feature"

## Context Priority

When generating the spec, collect and prioritize context in this order:

1. `docs/en/requirements.md` (if present)
2. `docs/en/design.md` (if present)
3. Currently opened files in the editor
4. User-selected code snippets
5. `README.md` in the current project
6. API documentation (if present)
7. User-provided text requirements

If canonical docs do not exist, scan for legacy filenames (best-effort):

- Requirements: `requirements.md`, `PRD.md`
- Design: `design.md`, `spec.md`

## Canonical Docs Paths

Default output targets (English):

- Requirements/PRD: `docs/en/requirements.md`
- Design/Spec: `docs/en/design.md`
- Tasks: `docs/en/tasks.md`

If legacy docs exist but canonical docs do not, treat legacy docs as inputs,
but write outputs to canonical paths to normalize the workflow.

## Boundary Rules (Authoritative)

Treat `../create-prd/references/prd_spec_boundary_template.md` as the single
source of truth for what belongs in PRD versus Spec.

This skill produces **Spec** content. It is allowed to include:

- Architecture diagrams and component responsibilities
- Data model and schema details
- API/interface contracts (including payloads and error codes)
- Runtime configs, flags, deployment and rollout considerations
- Detailed failure handling, retries, idempotency, and dedup strategies
- Verification plan (tests + observability)

## Interaction Workflow

### Step 1: Detect Starting Point

Classify input into one of three modes:

- **Mode A: Greenfield** (no existing docs; new system/feature)
- **Mode B: Brownfield** (existing system; PRD/design exists; change request)
- **Mode C: Incomplete context** (missing PRD, unclear scope)

### Step 2: Clarify If Needed (Minimal)

If details are ambiguous, ask only what is required to produce a safe spec:

- What is in-scope vs out-of-scope for this iteration?
- What are the primary non-functional targets (latency, reliability, cost)?
- What integrations are required (systems, data sinks/sources)?
- Any backwards-compatibility constraints?

### Step 3: Scan → Analyze → Merge (Incremental Update Logic)

If `docs/en/design.md` (or legacy design doc) exists:

- **Scan** the existing design to understand current components, contracts,
  and invariants.
- **Impact analysis (blast radius)**:
  - Identify affected components, data contracts, and interfaces.
  - Identify migration/backfill needs.
  - Identify backward compatibility risks.
- **Merge** changes into the existing document:
  - Insert additions/changes in the most relevant section.
  - Mark changed bullets/paragraphs with `[MODIFIED]`.
  - Mark newly added items with `[NEW]` when helpful.
  - Do not rewrite unrelated sections.

If no design doc exists:

- Generate a complete design doc from scratch.

### Step 4: Output

By default, write the spec to `docs/en/design.md`.

If the user requests a different location, follow the user, but keep the
content structure and traceability requirements.

## Output Requirements

Always output the spec in Markdown with all sections below.
Do not omit sections; use "TBD" when data is missing.

```markdown
## 1. Scope and Inputs
- PRD reference:
- In-scope implementation:
- Out-of-scope:

## 2. Architecture and Components
- Component diagram:
- Responsibilities:
- Data flow:

## 3. Data Contracts
- Entities and schema:
- Field definitions:
- Versioning/backward compatibility:

## 4. Interfaces
- APIs / message contracts:
- Error handling contract:

## 5. Processing Logic
- Main algorithm:
- Edge-case behavior:
- Idempotency and dedup strategy:

## 6. Runtime and Deployment
- Config/env variables:
- Scheduling/concurrency:
- Rollout/rollback:

## 7. Verification Plan
- Unit tests:
- Integration tests:
- E2E tests:
- Monitoring/alerts:
```

## Traceability Rules

- Every requirement ID from PRD (`FR-*`, `EX-*`, `AC-*`) that is in-scope must
  be referenced in the spec (or explicitly declared out-of-scope).
- Spec must not introduce new user-facing behavior without a corresponding PRD
  delta (call it out as an open decision).

## Few-Shot Examples (Compact)

### Example: Brownfield PRD update → Spec update

**User input**
`/create-spec-doc add points reward system to existing checkout flow`

**Expected behavior**

- Read current PRD and design doc.
- Produce an impact analysis section inside relevant areas.
- Update schema/contracts and mark modified items with `[MODIFIED]`.

