## Stack

Stack is a collection that is based on the last-in-first-out (LIFO) policy.

It can be implemented with array or with linked list.

### Linked List

Pop | Push
:-: | :---:
O(1)| O(1) 

```swift
struct LinkedListStack<T> {
    private let linkedList = LinkedList<T>()

    mutating func pop() -> T? {
        return linkedList.removeHead()?.value
    }

    mutating func push(_ value: T) {
        linkedList.appendHead(value)
    }

    func peek() -> T? {
        return linkedList.head?.value
    }
}
```

### Array

Pop | Push
:-: | :---:
O(1)| O(1)

```swift
struct ArrayStack<T> {
    private var array = Array<T>()
    var count: Int {
        return array.count
    }

    mutating func pop() -> T {
        return array.removeLast()
    }

    mutating func push(_ value: T) {
        array.append(value)
    }

    func peek() -> T? {
        return array.last
    }
}
```

Usually it's useful to interate over stack, this can be done by implementing `Sequence` and `IteratorProtocol` protocols

```swift
extension ArrayStack: Sequence {
    struct StackItetator: IteratorProtocol {
        private var elements: [T]

        init(elements: [T]) {
            self.elements = elements
        }

        mutating func next() -> T? {
            guard !elements.isEmpty else { return nil }
            return elements.popLast()
        }
    }

    func makeIterator() -> StackItetator {
        return StackItetator(elements: array)
    }
}
```

In some cases array might need to be resized manually. In this case amortized complexity the same.

```swift
struct ResizableArrayStack<T> {
    private var array = Array<T?>(repeating: nil, count: 1)
    private var count = 0

    mutating func pop() -> T? {
        defer {
            resizeIfNeed()
        }
        count -= 1
        return array[count]
    }

    mutating func push(_ value: T) {
        array[count] = value
        count += 1
        resizeIfNeed()
    }

    func peek() -> T? {
        return array[count - 1]
    }

    mutating private func resizeIfNeed() {
        if count == array.count {
            resizeTo(size: count * 2)
        } else if count <= array.count / 4 {
            resizeTo(size: array.count / 2)
        }
    }

    mutating private func resizeTo(size: Int) {
        var newArray = Array<T?>(repeating: nil, count: size)
        newArray[0..<count] = array[0..<count]
        array = newArray
    }
}
```