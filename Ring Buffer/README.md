## Ring Buffer

A ring buffer, or circular queue, is a FIFO data structure of a fixed size N.

Write | Read
:---: | :---:
O(1)  | O(1) 

```swift
struct RingBuffer<T> {
    private var array: Array<T?>
    private var filledCount = 0
    private var readIndex = 0
    private var writeIndex: Int { return (readIndex + filledCount) % array.capacity }

    init(capacity: Int) {
        array = Array<T?>(repeating: nil, count: capacity)
    }

    mutating func write(_ value: T) {
        array[writeIndex] = value

        if filledCount == array.capacity {
            readIndex = (readIndex + 1) % array.capacity
        } else {
            filledCount += 1
        }
    }

    mutating func read() -> T? {
        guard filledCount > 0 else { return nil }

        defer {
            array[readIndex] = nil
            readIndex = (readIndex + 1) % array.capacity
            filledCount -= 1
        }

        return array[readIndex]
    }
}
```