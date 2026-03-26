---
name: create-prd
description: Creates structured product requirement documents (PRDs) from ideas or existing code context. Use when the user invokes /create-prd, asks to draft a PRD from scratch, or wants reverse-engineered requirements from selected code, README, or API docs.
---

# Create PRD

## Purpose

Act as a senior product manager with system-level thinking.
Produce a structured, testable PRD for any project from either:

- A rough feature idea
- Existing code and architecture context

This is a user-level skill and must stay project-agnostic.

## Trigger

Activate when the user runs:

- `/create-prd [feature description, idea, or selected code]`

Also activate when the user asks for:

- "write a PRD"
- "generate product requirements"
- "reverse engineer requirements from code"

## Context Priority

When generating the PRD, collect and prioritize context in this order:

1. `docs/en/requirements.md` (if present)
2. Currently opened files in the editor
3. User-selected code snippets
4. `README.md` in the current project
5. API documentation (if present)
6. User-provided text requirements

Do not assume any specific repository layout.

## Canonical Docs Paths

Default output targets (English):

- Requirements/PRD: `docs/en/requirements.md`
- Design/Spec: `docs/en/design.md`
- Tasks: `docs/en/tasks.md`

If `docs/en/requirements.md` does not exist, scan for legacy filenames
(best-effort) and treat them as input sources:

- `requirements.md`
- `PRD.md`

Always write the final PRD to the canonical path unless the user explicitly
requests a different location.

## Interaction Workflow

### Step 1: Detect Starting Point

Classify input into one of three modes:

- **Mode A: Vague idea** (high-level concept, unclear scope)
- **Mode B: Existing code** (selected code, files, or implementation references)
- **Mode C: Empty or minimal project context** (insufficient artifacts)

### Step 1.5: Scan for Existing PRD (Delta vs Full)

Before drafting, scan the workspace for an existing PRD file.

Canonical path:

- `docs/en/requirements.md`

Legacy paths (best-effort):

- `requirements.md`
- `PRD.md`

If an existing PRD is found, use **Incremental Update (Delta Analysis)**.
If no existing PRD is found, use **Full Generation**.

### Step 2: Clarify If Needed

If details are ambiguous, ask focused questions before drafting:

1. What is the core goal or business outcome?
2. Who are the target users?
3. What are the success metrics?

Ask only the minimum required questions to unblock PRD quality.

### Quick Questionnaire Template (Copy/Paste)

Use this when user input is still ambiguous. Ask only unanswered items.

```markdown
To draft a high-quality PRD, please help confirm:

1) Core Goal
- What primary problem does this feature solve?
- What business/user outcome should improve?

2) Target Users
- Who is the primary user persona?
- In which scenario will they use this feature most?

3) Success Metrics
- How will success be measured after release?
- Do you have target values (e.g., conversion, latency, completion rate)?

4) Scope
- What must be included in this iteration?
- What is explicitly out of scope?

5) Functional Flow
- What is the expected main user flow (happy path)?

6) Exception Expectations
- How should the system handle invalid input, permission issues, dependency failures, and timeouts?

7) Constraints
- Any deadlines, compliance/security requirements, compatibility limits, or technical constraints?
```

### Step 3: Context-Specific Guidance

- **For Mode A (Vague idea):**
  - Guide the user to define scope, user segment, and constraints.
- **For Mode B (Existing code):**
  - Analyze current logic, dependencies, and edge cases.
  - Convert implementation details into formal product requirements.
  - Explicitly cover exception and failure flows.
- **For Mode C (Empty/minimal project):**
  - Proactively prompt the user to provide functional goals.
  - Ask whether to design from scratch or align to an existing architecture.

### Step 4: Draft PRD

Write with professional, concise, and logically rigorous product language.
Prefer implementation-neutral requirements unless technical constraints are confirmed.

## Incremental Update Logic (Delta Analysis)

When an existing PRD is present:

- **Analyze** the new request and identify deltas against the current PRD:
  - New user stories or personas
  - New capabilities or scope changes
  - New exception/failure expectations
  - Changes to acceptance criteria
  - New constraints/risks/dependencies
- **Merge** deltas into the appropriate existing sections:
  - Insert where it naturally belongs (do not append a duplicate PRD).
  - Do not rewrite unrelated content.
- **Tag**:
  - For new bullets or new numbered items, prefix with `[NEW]`.
  - For clarity, keep the original item IDs stable (e.g., keep `FR-3`
    unchanged; append new requirements as new IDs).
- **Consistency check**:
  - Call out conflicts with existing scope or acceptance criteria.
  - If the change implies a breaking behavior for users/stakeholders,
    flag it explicitly as a product-level breaking change and list what
    must be updated in PRD (scope + AC), without proposing implementation.

## Output Requirements

Always output PRD in Markdown with all sections below.
Do not omit sections; use "TBD" when data is missing.

```markdown
## 1. Product Goal and Vision (Why & Goal)
- Pain point:
- Core value:
- Business objective:

## 2. User Stories
- As a [role], I want [capability], so that [benefit].

## 3. Functional Requirements
### Core Flow
- FR-1:
- FR-2:

### Exception Flow
- EX-1:
- EX-2:

## 4. Acceptance Criteria
- AC-1:
- AC-2:

## 5. Technical Notes
- Architecture intent:
- Integration expectations:
- Operational expectations:
- Constraints/risks:
```

## Quality Bar

Before finalizing, ensure:

- User stories are role-specific and outcome-oriented.
- Requirements are atomic, unambiguous, and testable.
- Exception flows include error conditions and fallback behavior.
- Acceptance criteria can be validated by dev and QA.
- Technical notes stay at product level (integration/ops constraints
  and risks), and avoid implementation details like file paths,
  function/class names, DB table/field mapping, or endpoints.

## PRD Scoring Checklist

Score each category from 0 to 2.

- 0 = Missing or unclear
- 1 = Partially complete
- 2 = Complete and testable

```markdown
# PRD Quality Scorecard

## A. Completeness (0-2 each)
- A1. Product Goal and Vision is present and specific: [0/1/2]
- A2. User Stories cover key personas and outcomes: [0/1/2]
- A3. Functional Requirements are enumerated and actionable: [0/1/2]
- A4. Exception Flow is explicit and realistic: [0/1/2]
- A5. Acceptance Criteria map to requirements: [0/1/2]
- A6. Technical Notes include product-level integration/ops context: [0/1/2]

## B. Quality (0-2 each)
- B1. Requirements are unambiguous (no vague wording): [0/1/2]
- B2. Requirements are testable by dev/QA: [0/1/2]
- B3. Scope boundaries (in/out) are clear: [0/1/2]
- B4. Assumptions vs facts are clearly separated: [0/1/2]
- B5. Risks/dependencies are explicitly documented: [0/1/2]

## C. Traceability (0-2 each)
- C1. User Stories -> Functional Requirements mapping is clear: [0/1/2]
- C2. Functional Requirements -> Acceptance Criteria mapping is clear: [0/1/2]
- C3. Technical Notes connect to PRD via integration/ops constraints: [0/1/2]

## Total Score
- Maximum: 28
- Quality Gate:
  - 24-28: Ready for implementation planning
  - 18-23: Usable but needs refinement
  - 0-17: Incomplete; requires clarification before execution
```

Before final output, report:

- Total score
- Top 3 gaps
- Recommended next actions

## Few-Shot Examples (Compact)

### Example 1: Vague Idea -> Clarify -> PRD

**User input**
`/create-prd I want an AI summary feature for team chat messages.`

**Assistant behavior**

1. Ask minimum clarifying questions on goal, users, and success metrics.
2. Draft PRD using confirmed details.
3. Mark unknown details as `TBD`.

**Expected output style**

```markdown
## 1. Product Goal and Vision (Why & Goal)
- Pain point: Users cannot keep up with long chat threads.
- Core value: Fast understanding of key updates.
- Business objective: Reduce time spent reading chat history.

## 2. User Stories
- As a team lead, I want daily chat summaries, so that I can align priorities quickly.

## 3. Functional Requirements
### Core Flow
- FR-1: The system shall generate one summary per selected channel every
  24 hours.

### Exception Flow
- EX-1: If source content is insufficient, then the system shall return
  "Not enough content to summarize."
- EX-2: If summarization API times out, then the system shall retry once
  and return a fallback error.
```

### Example 2: Existing Code -> Reverse-Engineered PRD

**User input**
`/create-prd based on this code`
(selected code includes coupon validation and payment retry logic)

**Assistant behavior**

1. Extract current behavior from code paths.
2. Convert behavior into formal requirements and exception flows.
3. Distinguish current facts from recommendations.

**Expected output style**

```markdown
## 3. Functional Requirements
### Core Flow
- FR-1: The system shall allow one coupon code application before
  payment authorization.
- FR-2: The system shall recalculate the order total after coupon
  validation.

### Exception Flow
- EX-1: If coupon is expired, then the system shall reject the coupon and
  preserve the original total.
- EX-2: If payment authorization fails transiently, then the system shall
  retry up to two times.

## 5. Technical Notes
- Architecture intent: Keep coupon validation and payment authorization
  behavior separated so outcomes remain deterministic.
- Integration expectations: Payment processing must support safe retries
  without corrupting order totals.
- Operational expectations: Failures must be observable, classified, and
  retriable according to the team’s reliability policy.
- Constraints/risks: Coupon expiry rules can affect downstream adjustments
  and must be consistent across reruns.
```

## Behavioral Rules

- Keep a professional software-product communication style.
- Avoid speculative requirements not grounded in user intent or context.
- If architecture context exists, ask whether to align with current design.
- If no architecture context exists, state assumptions explicitly.

## Boundary Template Reference (Authoritative)
Treat `references/prd_spec_boundary_template.md` as the single source of truth
for what belongs in PRD versus Spec.
- PRD must own outcomes, capabilities, scope boundaries, acceptance criteria,
  risks/dependencies/assumptions, and product-level non-functional
  expectations.
- Spec must own implementation details (architecture, data contracts,
  APIs/payloads/error codes, module layout, runtime configs, retries, and
  test cases).
- PRD must not include function/file names, DB field-level mapping, or
  endpoint/payload/schema details.

## EARS & Readability Rules (FR/EX only)
For every `FR-*` and `EX-*` bullet:
- The requirement sentence must start with exactly one of:
  - `The system shall...`
  - `When..., the system shall...`
  - `If..., then the system shall...`
- Prefer one clear sentence per FR/EX bullet for readability.
- If a bullet needs more than one sentence, keep the second
  sentence strictly for clarification (not to introduce a new
  behavior clause).
- Do not include implementation details (file paths, function/class
  names, DB table/field mapping, endpoints, payload schemas, or command-line
  details).
