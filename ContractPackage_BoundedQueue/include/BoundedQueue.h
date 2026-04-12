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


