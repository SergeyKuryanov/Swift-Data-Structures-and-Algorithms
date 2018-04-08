## Deque

A double-ended queue or deque (pronounced “deck”) is like a stack or a queue but supports adding and removing items at both ends.

It can be implemented with array or with linked list.

### Linked List

PopLeft | PopRight | PushLeft | PushRight
:-----: | :------: | :------: | :------: 
O(1)    | O(1)     | O(1)     | O(1)

```swift
struct LinkedListDeque<T> {
    private let linkedList = LinkedList<T>()

    private(set) var size = 0

    mutating func popLeft() -> T? {
        guard size > 0 else { return nil }
        size -= 1
        return linkedList.removeHead()?.value
    }

    mutating func popRight() -> T? {
        guard size > 0 else { return nil }
        size -= 1
        return linkedList.removeTail()?.value
    }

    mutating func pushLeft(_ value: T) {
        size += 1
        linkedList.appendHead(value)
    }

    mutating func pushRight(_ value: T) {
        size += 1
        linkedList.appendTail(value)
    }
}
```

### Resizable Array

All operations have amortized complexity.

PopLeft | PopRight | PushLeft | PushRight
:-----: | :------: | :------: | :------: 
O(1)    | O(1)     | O(1)     | O(1)

```swift
struct ResizableArrayDeque<T> {
    private var array = Array<T?>(repeating: nil, count: 1)
    private var headIndex = 0
    private var tailIndex = 0
    var size: Int {
        return tailIndex - headIndex + 1
    }

    mutating func popLeft() -> T? {
        guard size > 0 else { return nil }

        defer {
            array[headIndex] = nil
            headIndex += 1
            resizeIfNeed()
        }

        return array[headIndex]
    }

    mutating func popRight() -> T? {
        guard size > 0 else { return nil }

        defer {
            array[tailIndex] = nil
            tailIndex -= 1
            resizeIfNeed()
        }

        return array[tailIndex]
    }

    mutating func pushLeft(_ value: T) {
        headIndex -= 1
        resizeIfNeed()
        array[headIndex] = value
    }

    mutating func pushRight(_ value: T) {
        tailIndex += 1
        resizeIfNeed()
        array[tailIndex] = value
    }

    mutating private func resizeIfNeed() {
        if headIndex < 0 || tailIndex >= array.count {
            resizeTo(size: size * 2)
        } else if size <= array.count / 4 {
            resizeTo(size: array.count / 2)
        }
    }

    mutating private func resizeTo(size newSize: Int) {
        var newArray = Array<T?>(repeating: nil, count: newSize)

        let newHead = (newSize - size) / 2
        let newTail = newHead + size - 1

        newArray[newHead...newTail] = array[max(headIndex, 0)...min(tailIndex, array.count - 1)]
        headIndex = newHead
        tailIndex = newTail
        array = newArray
    }
}
```