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

extension RingBuffer: CustomStringConvertible {
    public var description: String {
        return "r: \(readIndex) w: \(writeIndex) - \(array.compactMap { $0 })"
    }
}

var ringBuffer = RingBuffer<Int>(capacity: 5)
ringBuffer.write(1)
ringBuffer.write(2)
ringBuffer.read()
ringBuffer.write(3)
ringBuffer.write(4)
ringBuffer.read()
ringBuffer.read()
ringBuffer.write(5)
ringBuffer.write(6)
