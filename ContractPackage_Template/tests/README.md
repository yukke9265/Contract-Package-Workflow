# Acceptance Test Skeleton

このフォルダには、`contract/04_AcceptanceCriteria.md` に対応する黒箱受け入れテストを置く。

## 使い方

- `AT-xx` ごとに、契約上の観点に対応するテストを用意する
- 実装詳細ではなく観測可能な結果だけを検証する
- 必要ならテスト補助関数で入力データや一時ファイルを生成する

## 注意

- 期待値の正本は `contract/04_AcceptanceCriteria.md`
- 公開ヘッダの外にある内部状態は検証対象にしない
- view や参照を返す API は、寿命と無効化規則に従って検証する
