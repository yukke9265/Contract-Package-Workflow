# Contract-Package Workflow

> A contract-first C++ workflow where AI implements from frozen contract packages and humans review the contract.
> 凍結した契約パッケージを基準に AI が実装し、人間が契約をレビューするための C++ 契約先行ワークフロー。

This repository packages a reusable workflow for contract-first C++ development. Public APIs, ownership, lifetime, invalidation rules, exception policy, and acceptance criteria are frozen first, then implementation and black-box tests are derived from the contract package.

このリポジトリは、契約先行の C++ 開発を再利用可能な形でまとめたものです。公開 API、所有権、寿命、無効化規則、例外方針、受け入れ条件を先に固定し、その契約パッケージだけを根拠に実装と黒箱テストを進めます。

## Contents / 何が入っているか

- [ContractPackage_Template](ContractPackage_Template): Generic template for creating a new contract package.
  [ContractPackage_Template](ContractPackage_Template): 新しい契約パッケージを作るための汎用テンプレート。
- [scripts](scripts): Scripts for package creation, validation, environment setup, and build/test execution.
  [scripts](scripts): 契約パッケージ生成、検証、環境初期化、build/test 実行スクリプト。
- [CONTRACT_WORKFLOW.md](CONTRACT_WORKFLOW.md): Detailed workflow, role split, and review gates.
  [CONTRACT_WORKFLOW.md](CONTRACT_WORKFLOW.md): 詳細なワークフロー、役割分担、レビューゲート。
- [.github](.github): Copilot instructions, custom agents, and reusable prompts.
  [.github](.github): Copilot 用 instructions、custom agents、prompt。

## Workflow / 基本フロー

1. Create a new contract package from [ContractPackage_Template](ContractPackage_Template).
   [ContractPackage_Template](ContractPackage_Template) から新しい契約パッケージを生成する。
2. Fill `contract/` and `include/`, then review the contract with a human reviewer.
   `contract/` と `include/` を埋めて、人間が契約レビューする。
3. Run the validator to detect unresolved items and structural issues.
   validator で未記入項目と構造を確認する。
4. Let AI implement strictly from the contract package.
   AI が契約だけを根拠に実装する。
5. Verify behavior with black-box acceptance tests in `tests/`.
   `tests/` の黒箱受け入れテストで検証する。
6. Run build and test through a CMake preset.
   CMake preset 経由で build と test を流す。

## Roles / AI と人間の分担

### AI Agents / AI エージェント

- Generate contract packages and draft `contract/` and `include/`.
  契約パッケージの生成と `contract/`、`include/` の下書き作成。
- Keep `contract/` and `include/` consistent.
  `contract/` と `include/` の整合維持。
- Implement code strictly from the frozen contract.
  凍結済み契約を根拠にした実装作成。
- Run build and test.
  build と test の実行。
- Detect and report contract gaps instead of guessing behavior.
  契約不足を検出し、推測で埋めずに報告する。

### Human Review / 人間レビュー

- Decide requirements and user expectations.
  要件と利用者期待を判断する。
- Approve whether the contract is sufficient and valid.
  契約の十分性と妥当性を承認する。
- Review whether acceptance criteria are adequate.
  受け入れ条件の妥当性を確認する。
- Decide whether a requested change is a contract change or an implementation fix.
  変更要求が契約変更か実装修正かを判断する。

## Quick Commands / すぐ使うコマンド

Create a new contract package:
新しい契約パッケージを作る:

```powershell
./scripts/New-ContractPackage.ps1 \
  -PackageName MyComponent \
  -InterfaceName MyComponent \
  -ModuleName mymodule \
  -PublicHeader MyComponent.h \
  -ImplementationFile MyComponent.cpp \
  -StatusType MyStatus
```

Validate a contract package:
契約パッケージを検証する:

```powershell
./scripts/Validate-ContractPackage.ps1 -PackagePath ./ContractPackage_MyComponent
```

Initialize the Visual Studio CMake environment (run once per shell session before build/test):
Visual Studio CMake 環境を初期化する（ビルド・テスト前にセッションごとに一度実行する）:

```powershell
. ./scripts/Initialize-VsCMakeEnv.ps1
```

Build and test with the Visual Studio C++ environment initialized:
Visual Studio 開発環境込みで build/test する:

```powershell
./scripts/Invoke-CMakePreset.ps1 -Preset x64-debug -Build -Test
```

## Use From VS Code / VS Code から使う

- prompt: New Contract Package
- prompt: Implement From Contract Package
- prompt: Init CMake DevShell
- prompt: Build And Test CMake Preset
- task: CMake: Build x64 Debug
- task: CMake: Test x64 Debug
- task: CMake: Build And Test x64 Debug

## More Details / 詳細ドキュメント

See [CONTRACT_WORKFLOW.md](CONTRACT_WORKFLOW.md) for the detailed workflow, role split, review gates, and Mermaid diagrams.

[CONTRACT_WORKFLOW.md](CONTRACT_WORKFLOW.md) に、詳細なワークフロー、AI と人間の責務、レビューゲート、Mermaid 図をまとめています。
