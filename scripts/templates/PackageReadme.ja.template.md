# [InterfaceName] Contract Package

このパッケージは、[InterfaceName] の契約駆動実装に必要な契約文書、公開ヘッダ、受け入れテスト骨格をまとめた配布単位です。

対象モジュールは [ModuleName] で、公開 API の結果通知には [StatusType] を使う前提で初期化されています。

## このパッケージで固定すること

- 仕様の正本は contract/ と include/ のみ
- 公開ヘッダは include/[PublicHeader] を基準に凍結する
- 実装ファイルは [ImplementationFile] を想定する
- tests/ は契約に対応する黒箱受け入れ観点を置く
- 契約にない振る舞いを足す場合は、先に契約を更新する

## 構成

- contract/01_Overview.md : シナリオ、責務、前提
- contract/02_InterfaceContract.md : 公開 API、寿命、無効化規則
- contract/03_ErrorModel.md : 状態コード、失敗時の状態
- contract/04_AcceptanceCriteria.md : 黒箱受け入れ観点
- include/[PublicHeader] : 凍結する公開ヘッダ
- tests/[InterfaceName]_acceptance.cpp : 受け入れテスト骨格
- CMakeLists.txt : パッケージ単体でもルート集約配下でも build できる CMake 定義

## 使い方

1. contract/ を埋めて契約レビューを完了する
2. include/[PublicHeader] の公開ヘッダを凍結する
3. [ImplementationFile] をこのパッケージだけを根拠に実装する
4. tests/[InterfaceName]_acceptance.cpp を contract/04_AcceptanceCriteria.md に対応づける
5. 必要ならルートの CMakeLists.txt に add_subdirectory(ContractPackage_[PackageName]) を追加して全体 build に含める

## 補足

- package-local CMake を使えば、このフォルダだけを単体で configure / build / test できる
- ドメイン固有の説明やスコープ外は、契約が固まった段階でこの README に追記する
