# Implementation Brief

## 目的

`BoundedQueue` を、契約文書と公開ヘッダだけを根拠に実装する。

## 仕様の正本

- `contract/01_Overview.md`
- `contract/02_InterfaceContract.md`
- `contract/03_ErrorModel.md`
- `contract/04_AcceptanceCriteria.md`
- `include/BoundedQueue.h`

## 実装者への制約

- 上記以外の文書や既存実装を仕様根拠として使わない
- 公開シグネチャを変更しない
- 例外方針を変更しない
- 所有権、寿命、無効化規則を破らない
- 契約違反入力を未定義動作にしない
- 契約に未記載の副作用や状態コードを公開しない

## 実装側に委ねる事項

- アルゴリズム選定
- 内部データ構造
- バッファ管理方式
- 最適化方法
- 非公開補助クラスの設計

## 受け入れ条件

- `tests/` の観点を満たすこと
- `contract/` の事前条件、事後条件、エラーモデルに反しないこと
- `include/BoundedQueue.h` に一致する実装であること

## 納品物

- `BoundedQueue.cpp`
- 必要なら非公開の内部ヘッダ
- 契約テストを通すための実装補助コード

