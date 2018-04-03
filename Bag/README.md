## Bag

Add | Count
:--------: | :---:
O(1)       | O(1) 

A bag is a collection where removing items is not supported.

It can be implemented with array or with linked list.

### Array

```swift
struct ArrayBag<Item> {
    var count: Int {
        return storage.count
    }

    var isEmpty: Bool {
        return count == 0
    }

    private var storage = Array<Item>()
    private var current = 0

    mutating func add(_ item: Item) {
        storage.append(item)
    }
}

extension ArrayBag: Sequence, IteratorProtocol {
    mutating func next() -> Item? {
        guard current < storage.count else { return nil }

        defer { current += 1 }
        return storage[current]
    }
}
```
### Linked List

```swift
class LinkedListBag<T> {
    private class Item {
        let value: T
        let next: Item?

        init(value: T, next: Item?) {
            self.value = value
            self.next = next
        }
    }

    private(set)var count = 0

    var isEmpty: Bool {
        return count == 0
    }

    private var firstItem: Item?
    private var currentItem: Item?

    func add(_ value: T) {
        let item = Item(value: value, next: firstItem)
        firstItem = item
        currentItem = firstItem
        count += 1
    }
}

extension LinkedListBag: Sequence, IteratorProtocol {
    func next() -> T? {
        guard let item = currentItem else { return nil }
        currentItem = item.next

        return item.value
    }
}
```