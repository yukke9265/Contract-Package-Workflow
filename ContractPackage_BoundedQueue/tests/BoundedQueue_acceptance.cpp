#include "BoundedQueue.h"

#include <cassert>

namespace {

void AT_01_PushPopInFifoOrder()
{
    BoundedQueue queue;
    int value = 0;

    assert(queue.Initialize(2) == QueueStatus::ok);
    assert(queue.Push(1) == QueueStatus::ok);
    assert(queue.Push(2) == QueueStatus::ok);
    assert(queue.Pop(value) == QueueStatus::ok);
    assert(value == 1);
    assert(queue.Pop(value) == QueueStatus::ok);
    assert(value == 2);

    assert(queue.IsEmpty());
}

void AT_02_FullAndEmptyBoundaries()
{
    BoundedQueue queue;
    int value = 0;

    assert(queue.Initialize(1) == QueueStatus::ok);
    assert(queue.Push(42) == QueueStatus::ok);
    assert(queue.Push(43) == QueueStatus::full);
    assert(queue.Pop(value) == QueueStatus::ok);
    assert(value == 42);

    assert(queue.Pop(value) == QueueStatus::empty);
}

void AT_03_PreconditionFailuresAreObservable()
{
    BoundedQueue queue;
    BoundedQueue invalid_queue;
    int value = 0;

    assert(queue.Push(1) == QueueStatus::not_initialized);
    assert(queue.Pop(value) == QueueStatus::not_initialized);
    assert(queue.Clear() == QueueStatus::not_initialized);
    assert(invalid_queue.Initialize(0) == QueueStatus::invalid_capacity);

    assert(!invalid_queue.IsInitialized());
}

}

int main()
{
    AT_01_PushPopInFifoOrder();
    AT_02_FullAndEmptyBoundaries();
    AT_03_PreconditionFailuresAreObservable();
}

