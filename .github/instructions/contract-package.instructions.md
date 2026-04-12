---
description: "Use when creating, editing, reviewing, or validating a C++ contract package, contract-driven workflow, public header contract, acceptance criteria, ownership/lifetime rules, or black-box implementation package."
applyTo: "ContractPackage_*/**,ContractPackage_Template/**"
---
# Contract Package Instructions

- 仕様の正本は `contract/` と `include/` に限定する。
- `contract/02_InterfaceContract.md` と `include/` の宣言は一致させる。
- 受け入れテストは `contract/04_AcceptanceCriteria.md` の ID と対応づける。
- 所有権、寿命、無効化規則、例外方針、ライフサイクルが未記入のままにしない。
- 実装自由度を書くときは、観測可能な振る舞いを削らずに内部方式だけ委ねる。
- テストは実装詳細ではなく観測可能な結果だけを検証する。
