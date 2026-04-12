# Placeholder Guide

以下のトークンを、対象ドメインに合わせて置換する。

## 名前系

- `BoundedQueue` — 公開クラスまたは公開インターフェース名
- `QueueStatus` — 状態コード enum または結果型名
- `/* replace with the primary operation call */` — 主操作名
- `target resource` — 対象リソース名
- `containers` — モジュール名
- `BoundedQueue.h` — 公開ヘッダ名
- `BoundedQueue.cpp` — 実装ファイル名

## C++ 契約系

- `C++20` — 例: C++20
- `MSVC 19.3x or later` — 例: MSVC 19.3x 以降
- `public API does not throw` — 例: 公開 API は例外を投げない
- `single instance is not thread-safe` — 例: 単一インスタンスはスレッドセーフではない
- `fill in for the target contract` — view / 参照 / iterator が無効になる条件
- `fill in for the target contract` — Open -> Read -> Close などの順序制約

## ドメイン系

- `fill in for the target contract` — 例: UTF-8 テキスト、バイナリ、JSON
- `fill in for the target contract` — 例: 既存の通常ファイル、null 非許容
- `observable result for the caller` — 利用者が観測する出力
- `primary failure kind 1`, `primary failure kind 2` — 主要な失敗種別

## テスト系

- `normal case` など — 受け入れ観点の具体名
- `/* prepare fixture */` — テスト前提を作る補助処理
- `/* replace with observable result */` — 契約上の期待結果

## 置換のコツ

- 先に `include/` を決める
- 次に `contract/02_InterfaceContract.md` を埋める
- その後 `03_ErrorModel.md` と `04_AcceptanceCriteria.md` を埋める
- `tests/` は contract の ID と文言を対応づける

