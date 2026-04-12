---
name: "Build And Test CMake Preset"
description: "Build and test this CMake workspace through the reusable preset script after initializing the Visual Studio developer environment."
agent: "agent"
model: "GPT-5 (copilot)"
tools: [execute, read]
argument-hint: "preset name such as x64-debug or x64-release"
---
Build and test the selected CMake preset using the reusable script flow.

Rules:
- Use `scripts/Invoke-CMakePreset.ps1`.
- Prefer the preset supplied by the user.
- If no preset is supplied, use `x64-debug`.
- Report compiler or environment failures separately from test failures.

Return:
- The preset used
- Whether configure, build, and test passed
- Any actionable error summary
