#include "include/BoundedQueue.h"

#include <memory>
#include <utility>

struct BoundedQueue::Storage {
    std::unique_ptr<int[]> buffer;
    std::size_t capacity = 0;
    std::size_t size = 0;
    std::size_t head = 0;
    std::size_t tail = 0;
    bool initialized = false;
};

BoundedQueue::BoundedQueue() noexcept
    : storage_(std::make_unique<Storage>())
{}

BoundedQueue::~BoundedQueue() noexcept
 = default;

BoundedQueue::BoundedQueue(BoundedQueue&& other) noexcept
    : storage_(std::move(other.storage_))
{
    if (!storage_) {
        storage_ = std::make_unique<Storage>();
    }
    other.storage_ = std::make_unique<Storage>();
}

BoundedQueue& BoundedQueue::operator=(BoundedQueue&& other) noexcept
{
    if (this != &other) {
        storage_ = std::move(other.storage_);
        if (!storage_) {
            storage_ = std::make_unique<Storage>();
        }
        other.storage_ = std::make_unique<Storage>();
    }
    return *this;
}

QueueStatus BoundedQueue::Initialize(std::size_t capacity) noexcept
{
    Storage& storage = *storage_;
    if (storage.initialized) {
        return QueueStatus::already_initialized;
    }
    if (capacity == 0) {
        return QueueStatus::invalid_capacity;
    }

    storage.buffer = std::make_unique<int[]>(capacity);
    storage.capacity = capacity;
    storage.size = 0;
    storage.head = 0;
    storage.tail = 0;
    storage.initialized = true;
    return QueueStatus::ok;
}

QueueStatus BoundedQueue::Push(int value) noexcept
{
    Storage& storage = *storage_;
    if (!storage.initialized) {
        return QueueStatus::not_initialized;
    }
    if (storage.size == storage.capacity) {
        return QueueStatus::full;
    }

    storage.buffer[storage.tail] = value;
    storage.tail = (storage.tail + 1) % storage.capacity;
    ++storage.size;
    return QueueStatus::ok;
}

QueueStatus BoundedQueue::Pop(int& out_value) noexcept
{
    Storage& storage = *storage_;
    if (!storage.initialized) {
        return QueueStatus::not_initialized;
    }
    if (storage.size == 0) {
        return QueueStatus::empty;
    }

    out_value = storage.buffer[storage.head];
    storage.head = (storage.head + 1) % storage.capacity;
    --storage.size;
    return QueueStatus::ok;
}

QueueStatus BoundedQueue::Clear() noexcept
{
    Storage& storage = *storage_;
    if (!storage.initialized) {
        return QueueStatus::not_initialized;
    }

    storage.size = 0;
    storage.head = 0;
    storage.tail = 0;
    return QueueStatus::ok;
}

bool BoundedQueue::IsInitialized() const noexcept
{
    return storage_->initialized;
}

bool BoundedQueue::IsEmpty() const noexcept
{
    const Storage& storage = *storage_;
    return !storage.initialized || storage.size == 0;
}

bool BoundedQueue::IsFull() const noexcept
{
    const Storage& storage = *storage_;
    return storage.initialized && storage.size == storage.capacity;
}

std::size_t BoundedQueue::Size() const noexcept
{
    return storage_->size;
}

std::size_t BoundedQueue::Capacity() const noexcept
{
    return storage_->capacity;
}