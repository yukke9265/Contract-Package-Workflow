# インターフェース契約

## 1. シグネチャ定義

```cpp
#pragma once

#include <cstddef>
#include <memory>

enum class QueueStatus {
    ok,
    empty,
    full,
    not_initialized,
    invalid_capacity,
    already_initialized
};

class BoundedQueue {
public:
    BoundedQueue() noexcept;
    ~BoundedQueue() noexcept;

    BoundedQueue(const BoundedQueue&) = delete;
    BoundedQueue& operator=(const BoundedQueue&) = delete;
    BoundedQueue(BoundedQueue&&) noexcept;
    BoundedQueue& operator=(BoundedQueue&&) noexcept;

    [[nodiscard]] QueueStatus Initialize(std::size_t capacity) noexcept;
    [[nodiscard]] QueueStatus Push(int value) noexcept;
    [[nodiscard]] QueueStatus Pop(int& out_value) noexcept;
    [[nodiscard]] QueueStatus Clear() noexcept;
    [[nodiscard]] bool IsInitialized() const noexcept;
    [[nodiscard]] bool IsEmpty() const noexcept;
    [[nodiscard]] bool IsFull() const noexcept;
    [[nodiscard]] std::size_t Size() const noexcept;
    [[nodiscard]] std::size_t Capacity() const noexcept;

private:
    struct Storage;
    std::unique_ptr<Storage> storage_;
};
```

## 2. 引数と戻り値

### 2.1 引数

| 名前 | 型 | 必須 | 形式 / 単位 | 制約 | 説明 |
| --- | --- | --- | --- | --- | --- |
| `capacity` | `std::size_t` | Y | 要素数 | 1 以上であること | `Initialize` で設定する最大格納数 |
| `value` | `int` | Y | 32-bit 整数 | 制約なし | `Push` する値 |
| `out_value` | `int&` | Y | 32-bit 整数 | `Pop` 成功時に上書きされる | 取り出した値の出力先 |

### 2.2 戻り値

| 名前 | 型 | 条件 | 説明 |
| --- | --- | --- | --- |
| `Initialize` の戻り値 | `QueueStatus` | 常時 | `ok` は初期化成功、その他は失敗理由 |
| `Push` の戻り値 | `QueueStatus` | 常時 | `ok` は追加成功、`full` は満杯、その他は失敗理由 |
| `Pop` の戻り値 | `QueueStatus` | 常時 | `ok` は取り出し成功、`empty` は空、その他は失敗理由 |
| `Clear` の戻り値 | `QueueStatus` | 常時 | `ok` は消去成功、`not_initialized` は未初期化 |
| `Size` / `Capacity` の戻り値 | `std::size_t` | 常時 | 現在要素数または設定容量 |

## 3. 所有権と寿命

- 引数の所有権: `out_value` は呼び出し側所有、それ以外は値渡し
- 戻り値の所有権: すべて値返しであり参照は返さない
- 参照やポインタの有効期間: `out_value` は呼び出し側が管理し、キュー内部への参照は公開しない
- コピー可否: 不可 (`= delete`)
- コピーコスト: 該当なし
- move後状態: move 元は `IsInitialized() == false`、`Size() == 0` を返す空状態

## 4. 無効化規則

- 参照 / ポインタ / iterator / view が無効になる条件: 内部要素への参照や view は公開しないため該当なし
- 取得済みハンドルの再利用可否: 該当なし
- キャッシュしてよい値: `QueueStatus`、`Size()`、`Capacity()` の値は次の更新操作まで利用可

## 5. ライフサイクル

- 生成条件: デフォルト構築可、`Initialize` 呼び出しで使用可能になる
- 初期状態: 直後は未初期化状態であり `IsInitialized() == false` を返す
- 呼び出し順制約: `Push`、`Pop`、`Clear` は `Initialize` 成功後にのみ意味を持つ。初期化後の再 `Initialize` は `already_initialized` を返す
- 破棄時副作用: 内部メモリがあれば解放する。例外は送出しない
- 再利用可否: 同一インスタンスの再初期化は不可。新しいキューが必要なら新しいインスタンスを作る

## 6. 事前条件

- `Initialize` に渡す `capacity` は 1 以上であること
- `Push`、`Pop`、`Clear` は `Initialize` 成功後に呼び出すこと
- 条件を満たさない場合も未定義動作にせず、`03_ErrorModel.md` に定義した状態コードを返す

## 7. 事後条件

- `Initialize` が `ok` のとき、`Capacity() == capacity`、`Size() == 0`、`IsEmpty() == true` になる
- `Push` が `ok` のとき、`Size()` は 1 増え、後続の `Pop` は FIFO 順で値を返す
- `Pop` が `ok` のとき、`out_value` は最も古い未取得値に更新され、`Size()` は 1 減る
- `Clear` が `ok` のとき、`Size()` は 0 になり、`Capacity()` は変化しない
- 失敗時は、`Push(full)` と `Pop(empty)` でキュー内容は変更されない

## 8. 副作用

| 種別 | あり / なし | 内容 |
| --- | --- | --- |
| データ更新 | あり | 内部キュー状態、格納値、要素数を更新する |
| 外部I/O | なし | なし |
| コールバック / 通知 | なし | なし |
| ログ出力 | なし | なし |

## 9. 並行性

- 同一インスタンスの同時呼び出し可否: 不可
- read-read 同時実行: 不可
- read-write 同時実行: 不可
- 排他要件: 複数スレッドから使う場合は呼び出し側が外部同期する
