# エラーモデル

## 1. 失敗通知方針

- 失敗通知方法: `QueueStatus` による戻り値通知
- `noexcept` 方針: 公開 API は全面的に `noexcept`
- 契約違反時の扱い: 例外は投げず、未初期化操作は `not_initialized`、無効容量は `invalid_capacity` を返す
- 未定義動作: 許可しない

## 2. 例外 / エラー返却

| 名前 | 発生条件 | 呼び出し側の期待動作 |
| --- | --- | --- |
| `QueueStatus::ok` | 操作成功 | 通常処理を継続する |
| `QueueStatus::empty` | 空のキューに `Pop` した | 値取得を中止し、必要なら後で再試行する |
| `QueueStatus::full` | 満杯のキューに `Push` した | 追加を中止し、必要なら `Pop` 後に再試行する |
| `QueueStatus::not_initialized` | `Initialize` 前に `Push` / `Pop` / `Clear` を呼んだ | 呼び出し順を修正し、`Initialize` を先に実行する |
| `QueueStatus::invalid_capacity` | `Initialize(0)` を呼んだ | 無効入力として中止し、正しい容量で再試行する |
| `QueueStatus::already_initialized` | 初期化後に再度 `Initialize` を呼んだ | 同一インスタンスの再初期化を行わず、新規インスタンスを使う |

## 3. 例外安全保証

| 操作 | 保証レベル | 説明 |
| --- | --- | --- |
| `BoundedQueue()` | no-throw | 例外を送出せず、未初期化の空状態を作る |
| `Initialize` | basic | 失敗時は未初期化状態または既存の初期化状態を保つ |
| `Push` | basic | `full` または `not_initialized` では内容を変更しない |
| `Pop` | basic | `empty` または `not_initialized` では内容を変更しない |

## 4. 部分更新と回復

- 部分成功の扱い: 不可。1 回の `Push` / `Pop` は成功か失敗のどちらか
- 失敗時の状態: `full`、`empty`、`not_initialized`、`invalid_capacity`、`already_initialized` ではキュー内容を変更しない
- 再試行可否: `full` は要素を取り出した後に可、`empty` は要素追加後に可、`invalid_capacity` は正しい容量で可、`already_initialized` は同一インスタンスでは不可
- 補償動作: 必要なし
