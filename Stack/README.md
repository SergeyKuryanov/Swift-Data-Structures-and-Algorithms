## Stack

Stack is a collection that is based on the last-in-first-out (LIFO) policy.

It can be implemented with array or with linked list.

### Linked List

Pop | Push
:-: | :---:
O(n)| O(1) 

```swift
class LinkedListStack<T> {
    private let linkedList = LinkedList<T>()

    func pop() -> T? {
        return linkedList.removeHead()?.value
    }

    func push(_ value: T) {
        linkedList.appendHead(value)
    }
}
```

### Array

Pop | Push
:-: | :---:
O(1)| O(1)

```swift
class ArrayStack<T> {
    private var array = Array<T?>()
    var count: Int {
        return array.count
    }

    func pop() -> T? {
        return array.removeLast()
    }

    func push(_ value: T) {
        array.append(value)
    }
}
```

In some cases array might need to be resized manually. In this case amortized complexity the same.

```swift
class ResizableArrayStack<T> {
    private var array = Array<T?>(repeating: nil, count: 1)
    private var count = 0

    func pop() -> T? {
        defer {
            resizeIfNeed()
        }
        count -= 1
        return array[count]
    }

    func push(_ value: T) {
        array[count] = value
        count += 1
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
        newArray[0..<count] = array[0..<count]
        array = newArray
    }
}
```