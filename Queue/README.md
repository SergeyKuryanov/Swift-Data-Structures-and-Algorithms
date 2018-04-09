## Queue

Queue is a collection that is based on the first-in-first-out (FIFO) policy.

It can be implemented with array or with linked list.

### Linked List

Enqueue | Dequeue
:-----: | :-----:
O(1)    | O(1) 

```swift
struct LinkedListQueue<T> {
    private let linkedList = LinkedList<T>()

    mutating func dequeue() -> T? {
        return linkedList.removeHead()?.value
    }

    mutating func enqueue(_ value: T) {
        linkedList.appendTail(value)
    }
}
```

### Array

Enqueue | Dequeue
:-----: | :-----:
O(1)    | O(n) 

```swift
struct ArrayQueue<T> {
    private var array = Array<T>()
    private var count: Int {
        return array.count
    }

    mutating func dequeue() -> T? {
        return array.removeFirst()
    }

    mutating func enqueue(_ value: T) {
        array.append(value)
    }
}
```

Usually it's useful to interate over queue, this can be done by implementing `Sequence` and `IteratorProtocol` protocols

```swift
extension ArrayQueue: Sequence {
    struct QueueItetator: IteratorProtocol {
        private var elements: [T]

        init(elements: [T]) {
            self.elements = elements
        }

        mutating func next() -> T? {
            guard !elements.isEmpty else { return nil }
            return elements.removeFirst()
        }
    }

    func makeIterator() -> QueueItetator {
        return QueueItetator(elements: array)
    }
}
```

### Resizable Array

Resizable implementation have constant amortized time.

Enqueue | Dequeue
:-----: | :-----:
O(1)    | O(1) 

```swift
struct ResizableArrayQueue<T> {
    private var array = Array<T?>(repeating: nil, count: 1)
    private var headIndex = 0
    private var tailIndex = 0
    private var count: Int {
        return tailIndex - headIndex
    }

    mutating func dequeue() -> T? {
        guard count > 0 else { return nil }

        defer {
            array[headIndex] = nil
            headIndex += 1
            resizeIfNeed()
        }

        return array[headIndex]
    }

    mutating func enqueue(_ value: T) {
        array[tailIndex] = value
        tailIndex += 1
        resizeIfNeed()
    }

    mutating private func resizeIfNeed() {
        if tailIndex >= array.count {
            resizeTo(size: count * 2)
        } else if count <= array.count / 4 {
            resizeTo(size: array.count / 2)
        }
    }

    mutating private func resizeTo(size: Int) {
        var newArray = Array<T?>(repeating: nil, count: size)
        newArray[0..<count] = array[headIndex..<tailIndex]
        array = newArray
        tailIndex = count
        headIndex = 0
    }
}
```

### Randomized Queue

Enqueue | Dequeue
:-----: | :-----:
O(1)    | O(1) 

Variation of queue, where order of items is randomized. Implemetation similar to `ResizableArrayQueue`, but use extra logic for randomization.

```swift
struct RandomizedQueue<T> {
    private var array = Array<T?>(repeating: nil, count: 1)
    private var headIndex = 0
    private var tailIndex = 0
    private var count: Int {
        return tailIndex - headIndex
    }

    mutating func dequeue() -> T? {
        guard count > 0 else { return nil }

        let randomIndex = Int(arc4random_uniform(UInt32(count))) + headIndex
        array.swapAt(headIndex, randomIndex)

        defer {
            array[headIndex] = nil
            headIndex += 1
            resizeIfNeed()
        }

        return array[headIndex]
    }

    mutating func enqueue(_ value: T) {
        array[tailIndex] = value
        tailIndex += 1
        resizeIfNeed()
    }

    mutating private func resizeIfNeed() {
        if tailIndex >= array.count {
            resizeTo(size: count * 2)
        } else if count <= array.count / 4 {
            resizeTo(size: array.count / 2)
        }
    }

    mutating private func resizeTo(size: Int) {
        var newArray = Array<T?>(repeating: nil, count: size)
        newArray[0..<count] = array[headIndex..<tailIndex]
        array = newArray
        tailIndex = count
        headIndex = 0
    }
}
```

To iterate over randomized queue we can use nice "hack", just deque all items from queue copy:

```swift
extension RandomizedQueue: Sequence {
    struct QueueItetator: IteratorProtocol {
        private var queue: RandomizedQueue

        init(queue: RandomizedQueue) {
            self.queue = queue
        }

        mutating func next() -> T? {
            return queue.dequeue()
        }
    }

    func makeIterator() -> QueueItetator {
        return QueueItetator(queue: self)
    }
}
```