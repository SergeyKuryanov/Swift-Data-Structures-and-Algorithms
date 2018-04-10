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

extension RingBuffer: CustomStringConvertible {
    public var description: String {
        return "r: \(readIndex) w: \(writeIndex) f: \(filledCount) - \(array.compactMap { $0 })"
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
ringBuffer.write(7)
ringBuffer.write(8)
ringBuffer.write(9)
