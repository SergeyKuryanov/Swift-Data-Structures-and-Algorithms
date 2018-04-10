## Ring Buffer

A ring buffer, or circular queue, is a FIFO data structure of a fixed size N.

Write | Read
:---: | :---:
O(1)  | O(1) 

```swift
struct RingBuffer<T> {
    private var array: Array<T?>
    private var readIndex = 0
    private var writeIndex = 0
    private var nextWriteMovesRead = false

    init(capacity: Int) {
        array = Array<T?>(repeating: nil, count: capacity)
    }

    mutating func write(_ value: T) {
        array[writeIndex] = value

        writeIndex += 1
        writeIndex = min(writeIndex, writeIndex % array.capacity)

        if nextWriteMovesRead {
            readIndex = writeIndex
            nextWriteMovesRead = false
        }

        if writeIndex == readIndex {
            nextWriteMovesRead = true
        }
    }

    mutating func read() -> T? {
        nextWriteMovesRead = false

        let value = array[readIndex]

        if value == nil {
            readIndex = 0
            writeIndex = 0
            return nil
        }

        array[readIndex] = nil
        readIndex += 1
        readIndex = min(readIndex, readIndex % array.capacity)

        return value
    }
}
```