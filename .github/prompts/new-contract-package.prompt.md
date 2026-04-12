---
name: "New Contract Package"
description: "Scaffold and fill a new C++ contract package from the workspace template for a target interface or module."
agent: "Contract Package Author"
model: "GPT-5 (copilot)"
argument-hint: "interface name, module name, header name, status/result type, and scenario"
---
Create a new C++ contract package from `ContractPackage_Template`.

Required inputs:
- Interface name
- Module name
- Public header name
- Implementation file name
- Status or result type name
- Short usage scenario

Workflow:
1. Copy the template into a new `ContractPackage_<name>` folder.
2. Replace placeholders consistently.
3. Fill `contract/` with a concrete black-box contract.
4. Freeze the public header under `include/`.
5. Add acceptance-test skeletons aligned to the contract IDs.

Return:
- The created package path
- The main contract decisions
- Any contract gaps that still need user input
