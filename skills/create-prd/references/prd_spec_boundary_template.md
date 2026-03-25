# PRD vs Spec Boundary Template

## Purpose

Use this template to clearly separate:
- **PRD (Product Requirement Document):** what and why
- **Spec (Technical Specification):** how

Goal: keep PM/RD/QA aligned on outcomes before implementation details are finalized.

---

## 1) Boundary Principles

- **PRD owns**
  - Business goals and success outcomes
  - User value and user stories
  - Functional capabilities and scope boundaries
  - Non-functional expectations at product level (for example reliability, latency targets)
  - Acceptance criteria and release readiness signals
  - Risks, dependencies, assumptions, and open decisions

- **Spec owns**
  - Architecture and component design
  - Data model, schema, and field definitions
  - API contracts, payloads, and error codes
  - File/module layout, class/function interfaces
  - Runtime configs, flags, deployment details
  - Detailed failure handling logic and retry mechanics
  - Test cases, test data, and implementation-level observability

- **Do not mix**
  - PRD should not include function names, file paths, DB field-level mapping, or command-line details.
  - Spec should not redefine product goals or change agreed scope without PRD update.

---

## 2) Quick Decision Checklist

Use these checks when writing a statement:

- If the sentence answers **"Why do we need this?"** -> PRD
- If the sentence answers **"What capability must users/stakeholders get?"** -> PRD
- If the sentence answers **"How will engineers implement it?"** -> Spec
- If the sentence contains concrete code/data interface details -> Spec
- If QA can validate it as behavior/outcome without reading code -> PRD

---

## 3) PRD Section Template (Outcome-Level)

Copy this for new PRDs:

```markdown
## 1. Product Goal and Vision
- Pain point:
- Core value:
- Business objective:

## 2. User Stories
- As a [role], I want [capability], so that [outcome].

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

## 5. Technical Notes (Product-Level)
- Architecture intent:
- Integration expectations:
- Operational expectations:
- Constraints/risks:
```

---

## 4) Spec Section Template (Implementation-Level)

Copy this for paired technical specs:

```markdown
## 1. Scope and Inputs
- PRD reference:
- In-scope implementation:
- Out-of-scope:

## 2. Architecture and Components
- Component diagram:
- Responsibilities:

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

---

## 5) PRD-to-Spec Handoff Rules

- Every PRD requirement (`FR-*`, `EX-*`, `AC-*`) must be traceable in spec sections.
- Spec cannot introduce new user-facing behavior without a PRD delta.
- If implementation constraints force scope change:
  - open a PRD change request
  - update acceptance criteria before implementation freeze

---

## 6) Review Roles and Focus

- **PM review focus**
  - Outcome clarity, scope boundaries, and release value
- **RD review focus**
  - Feasibility, architecture correctness, and operational safety
- **QA review focus**
  - Testability, acceptance traceability, and failure behavior coverage

---

## 7) Anti-Patterns

- Putting DB field-by-field mapping inside PRD
- Defining command examples and internal module names in PRD
- Writing vague spec statements like "handle errors properly" without explicit behavior
- Shipping implementation when PRD acceptance criteria are not testable

---

## 8) Completion Definition

Boundary is considered healthy when:
- PRD can be read and approved by PM/RD/QA without code context
- Spec can be implemented by RD without changing PRD meaning
- QA can derive test plans from PRD+Spec traceability matrix

