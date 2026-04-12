# Contract-Driven Workflow

## Source Of Truth

- 契約駆動の対象では `ContractPackage_*` または `ContractPackage_Template` を仕様の正本として扱う。
- 実装時の仕様根拠は `contract/` と `include/` に限定する。
- 契約にない振る舞いを追加したい場合は、先に契約を更新する。

## Implementation Rules

- C++ の公開 API では所有権、寿命、無効化規則、例外方針を曖昧にしない。
- 受け入れ条件は `tests/` の黒箱テストに対応づける。
- EOF と I/O エラー、契約違反は区別して観測可能にする。
- view や参照を返す API は、次に何で無効になるかを契約に明記する。

## Workflow

- 新規契約は `ContractPackage_Template` を複製して作る。
- 公開ヘッダを凍結してから実装に入る。
- 実装レビューより先に契約レビューを完了する。
- 実装依頼時は、契約パッケージ以外のファイルを仕様根拠にしない。
