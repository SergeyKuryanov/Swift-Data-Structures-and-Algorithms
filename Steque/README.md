## Steque

A stack-ended queue or steque is a data type that supports push, pop, and enqueue.

Pop | Push | Enqueue
:-: | :--: | :-----:
O(1)| O(1) | O(1)

```swift
struct Steque<T> {
    private let linkedList = LinkedList<T>()

    mutating func pop() -> T? {
        return linkedList.removeHead()?.value
    }

    mutating func push(_ value: T) {
        linkedList.appendHead(value)
    }

    mutating func enqueue(_ value: T) {
        linkedList.appendTail(value)
    }
}
```