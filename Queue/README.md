## Queue

Queue is a collection that is based on the first-in-first-out (FIFO) policy.

It can be implemented with array or with linked list.

### Linked List

Enqueue | Dequeue
:-----: | :-----:
O(n)    | O(1) 

```swift
class LinkedListQueue<T> {
    private let linkedList = LinkedList<T>()

    func dequeue() -> T? {
        return linkedList.removeHead()?.value
    }

    func enqueue(_ value: T) {
        linkedList.appendTail(value)
    }
}
```

### Array

Enqueue | Dequeue
:-----: | :-----:
O(1)    | O(n) 

```swift
class ArrayQueue<T> {
    private var array = Array<T?>()
    private var count: Int {
        return array.count
    }

    func dequeue() -> T? {
        return array.removeFirst()
    }

    func enqueue(_ value: T) {
        array.append(value)
    }
}
```

### Resizable Array

Resizable implementation have constant amortized time.

Enqueue | Dequeue
:-----: | :-----:
O(1)    | O(1) 

```swift
class ResizableArrayQueue<T> {
    private var array = Array<T?>(repeating: nil, count: 1)
    private var headIndex = 0
    private var tailIndex = 0
    private var count: Int {
        return tailIndex - headIndex
    }

    func dequeue() -> T? {
        guard count > 0 else { return nil }

        let value = array[headIndex]
        array[headIndex] = nil
        headIndex += 1
        resizeIfNeed()

        return value
    }

    func enqueue(_ value: T) {
        array[tailIndex] = value
        tailIndex += 1
        resizeIfNeed()
    }

    private func resizeIfNeed() {
        if count == array.count {
            resizeTo(size: count * 2)
        } else if count <= array.count / 4 {
            resizeTo(size: array.count / 2)
        }
    }

    private func resizeTo(size: Int) {
        var newArray = Array<T?>(repeating: nil, count: size)
        newArray[0..<count] = array[headIndex..<tailIndex]
        array = newArray
        tailIndex = count
        headIndex = 0
    }
}
```