---
name: "Implement From Contract Package"
description: "Implement C++ code from a selected contract package using only contract docs and the frozen public header as the specification source."
agent: "Contract Package Implementer"
model: "GPT-5 (copilot)"
argument-hint: "path to ContractPackage_* and target source path"
---
Implement the selected C++ component from a contract package.

Rules:
- Use only the selected package's `contract/` and `include/` as specification sources.
- Keep implementation details private.
- If the contract is ambiguous, stop and report the ambiguity instead of guessing.

Deliverables:
- `.cpp` implementation
- Any private helper files if needed
- Updated black-box acceptance tests when required

Return:
- Implemented files
- Covered acceptance criteria
- Remaining ambiguities, if any
