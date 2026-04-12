# Implementation Brief

## 目的

`Utf8LineReader` を、契約文書と公開ヘッダだけを根拠に実装する。

## 仕様の正本

- `contract/01_Overview.md`
- `contract/02_InterfaceContract.md`
- `contract/03_ErrorModel.md`
- `contract/04_AcceptanceCriteria.md`
- `include/Utf8LineReader.h`

## 実装者への制約

- 上記以外の文書や既存実装を仕様根拠として使わない
- 公開シグネチャを変更しない
- 例外方針を変更しない
- `std::string_view` の寿命と無効化規則を破らない
- EOF と I/O エラーを区別する
- 契約違反入力を未定義動作にしない

## 実装側に委ねる事項

- ファイル読み込み方法
- 内部バッファのデータ構造
- 改行検出方法
- UTF-8 検証の内部方式

## 受け入れ条件

- `tests/` の観点を満たすこと
- 契約に未記載の副作用を追加しないこと
- 契約に未記載の状態コードを公開しないこと

## 納品物

- `Utf8LineReader.cpp`
- 必要なら非公開の内部ヘッダ
- 契約テストを通すための実装補助コード
