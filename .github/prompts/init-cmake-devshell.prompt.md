---
name: "Init CMake DevShell"
description: "Initialize the Visual Studio C++ developer shell and bundled Ninja/CMake tools for this workspace using the reusable PowerShell script."
agent: "agent"
model: "GPT-5 (copilot)"
tools: [execute, read]
argument-hint: "architecture such as x64 or x86"
---
Initialize the reusable CMake developer environment for this workspace.

Rules:
- Use `scripts/Initialize-VsCMakeEnv.ps1`.
- Default to `x64` unless the user asked for `x86`.
- Report the resolved paths for `cl.exe`, `cmake.exe`, and `ninja.exe`.

Return:
- The architecture used
- The resolved tool paths
- Any environment setup failure
