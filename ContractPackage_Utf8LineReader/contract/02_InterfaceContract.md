# インターフェース契約

## 1. シグネチャ定義

```cpp
#pragma once

#include <filesystem>
#include <string_view>

enum class LineReaderStatus {
    ok,
    end_of_file,
    not_open,
    invalid_utf8,
    io_error
};

class Utf8LineReader {
public:
    Utf8LineReader() noexcept;
    ~Utf8LineReader() noexcept;

    Utf8LineReader(const Utf8LineReader&) = delete;
    Utf8LineReader& operator=(const Utf8LineReader&) = delete;
    Utf8LineReader(Utf8LineReader&&) noexcept;
    Utf8LineReader& operator=(Utf8LineReader&&) noexcept;

    [[nodiscard]] LineReaderStatus Open(const std::filesystem::path& path) noexcept;
    [[nodiscard]] LineReaderStatus ReadLine(std::string_view& out_line) noexcept;
    void Close() noexcept;
    [[nodiscard]] bool IsOpen() const noexcept;
};
```

## 2. 引数と戻り値

### 2.1 引数

| 名前 | 型 | 必須 | 形式 / 単位 | 制約 | 説明 |
| --- | --- | --- | --- | --- | --- |
| `path` | `const std::filesystem::path&` | Y | OSネイティブパス | 既存の通常ファイルを指すこと | 読み込み対象ファイル |
| `out_line` | `std::string_view&` | Y | UTF-8 テキスト | 呼び出し後に結果で上書きされる | 読み取った1行を受け取る出力引数 |

### 2.2 戻り値

| 名前 | 型 | 条件 | 説明 |
| --- | --- | --- | --- |
| `Open` の戻り値 | `LineReaderStatus` | 常時 | `ok` は open 成功、その他は失敗理由 |
| `ReadLine` の戻り値 | `LineReaderStatus` | 常時 | `ok` は1行取得、`end_of_file` は EOF、その他は失敗理由 |
| `IsOpen` の戻り値 | `bool` | 常時 | 読み取り可能な open 状態なら `true` |

## 3. 所有権と寿命

- 引数の所有権: `path` は借用、`out_line` は呼び出し側所有
- 戻り値の所有権: `out_line` は内部バッファ参照であり所有権は移譲しない
- 参照やポインタの有効期間: `out_line` は次回の `ReadLine` 呼び出し、`Close` 呼び出し、move、デストラクトのいずれか早い時点まで有効
- コピー可否: 不可 (`= delete`)
- コピーコスト: 該当なし
- move後状態: move 元は `IsOpen() == false` を返す有効だが空状態

## 4. 無効化規則

- 参照 / ポインタ / iterator / view が無効になる条件: `ReadLine` 再呼び出し後、`Close` 後、move 後、デストラクト後
- 取得済みハンドルの再利用可否: `out_line` に格納された過去の `std::string_view` は再利用不可
- キャッシュしてよい値: `LineReaderStatus` と `IsOpen()` の結果のみキャッシュ可。`out_line.data()` の保持は不可

## 5. ライフサイクル

- 生成条件: デフォルト構築可
- 初期状態: 直後は close 状態であり `IsOpen() == false`
- 呼び出し順制約: `ReadLine` は `Open` 成功後にのみ呼べる。`Open` 済みで再度 `Open` する前に `Close` すること
- 破棄時副作用: open 中であればファイルハンドルを閉じる。例外は送出しない
- 再利用可否: `Close` 後は別ファイルに対して再利用可

## 6. 事前条件

- `Open` に渡す `path` は通常ファイルを指していること
- `ReadLine` は `Open` が `ok` を返した後にのみ呼び出すこと
- `out_line` が指す以前の値を保持したまま次の `ReadLine` 結果も同時利用したい場合、呼び出し側がコピーを保持すること

## 7. 事後条件

- `Open` が `ok` のとき、その直後に `IsOpen()` は `true` を返す
- `ReadLine` が `ok` のとき、`out_line` は改行文字を含まない UTF-8 文字列を指す
- `ReadLine` が `end_of_file` のとき、読み取り位置は EOF にあり、以後の `ReadLine` も `end_of_file` を返す
- `ReadLine` が `io_error` または `invalid_utf8` のとき、以後の読み取り継続可否は保証しないため `Close` を要求する

## 8. 副作用

| 種別 | あり / なし | 内容 |
| --- | --- | --- |
| データ更新 | あり | 内部読み取り位置と内部行バッファを更新する |
| 外部I/O | あり | ファイルシステムから読み取る |
| コールバック / 通知 | なし | なし |
| ログ出力 | なし | なし |

## 9. 並行性

- 同一インスタンスの同時呼び出し可否: 不可
- read-read 同時実行: 不可
- read-write 同時実行: 不可
- 排他要件: 複数スレッドから触る場合は呼び出し側が外部同期する
