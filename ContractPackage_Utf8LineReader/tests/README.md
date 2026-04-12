# Acceptance Test Skeleton

`Utf8LineReader_acceptance.cpp` は契約に対応する最小の受け入れテスト雛形です。

## 使い方

- 実装者は `include/Utf8LineReader.h` に一致する `Utf8LineReader.cpp` を作成する
- テストプロジェクトからこのファイルと実装を一緒にビルドする
- `AT-04` と `AT-06` は環境依存の I/O 条件を含むため、必要に応じて追加する

## 注意

- このテストは実装詳細を検証しない
- 期待値は `contract/04_AcceptanceCriteria.md` を正本とする
- `std::string_view` は保持せず、必要なら `std::string` にコピーする
