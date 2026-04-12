# Placeholder Guide

以下のトークンを、対象ドメインに合わせて置換する。

## 名前系

- `[InterfaceName]` — 公開クラスまたは公開インターフェース名
- `[StatusType]` — 状態コード enum または結果型名
- `[PrimaryOperation]` — 主操作名
- `[ResourceType]` — 対象リソース名
- `[ModuleName]` — モジュール名
- `[PublicHeader]` — 公開ヘッダ名
- `[ImplementationFile]` — 実装ファイル名

## C++ 契約系

- `[LanguageVersion]` — 例: C++20
- `[CompilerVersion]` — 例: MSVC 19.3x 以降
- `[ExceptionPolicy]` — 例: 公開 API は例外を投げない
- `[ThreadSafety]` — 例: 単一インスタンスはスレッドセーフではない
- `[InvalidationRule]` — view / 参照 / iterator が無効になる条件
- `[LifecycleRule]` — Open -> Read -> Close などの順序制約

## ドメイン系

- `[InputFormat]` — 例: UTF-8 テキスト、バイナリ、JSON
- `[InputConstraint]` — 例: 既存の通常ファイル、null 非許容
- `[ObservableValue]` — 利用者が観測する出力
- `[FailureKind1]`, `[FailureKind2]` — 主要な失敗種別

## テスト系

- `[AT-01 description]` など — 受け入れ観点の具体名
- `[TestFixtureSetup]` — テスト前提を作る補助処理
- `[ExpectedBehavior]` — 契約上の期待結果

## 置換のコツ

- 先に `include/` を決める
- 次に `contract/02_InterfaceContract.md` を埋める
- その後 `03_ErrorModel.md` と `04_AcceptanceCriteria.md` を埋める
- `tests/` は contract の ID と文言を対応づける
