## Priority Queue

Priority Queue is an abstract data type which is like a regular queue or stack data structure, but where additionally each element has a "priority" associated with it. In a priority queue, an element with high priority is served before an element with low priority.

Insert | DeleteMax
:----: | :-------:
O(log(n))   | O(log(n))

```swift
struct PriorityQueue<Item: Comparable> {
    private var storage = [Item]()
    private var priorityFunction: (_ lhs: Item, _ rhs: Item) -> Bool

    init(priorityFunction: @escaping (_ lhs: Item, _ rhs: Item) -> Bool) {
        self.priorityFunction = priorityFunction
    }

    mutating func insert(_ item: Item) {
        storage.append(item)
        swim(storage.count - 1)

    }

    mutating func deleteMax() -> Item? {
        guard storage.count > 0 else { return nil }

        storage.swapAt(0, storage.count - 1)
        let max = storage.removeLast()
        sink(0)
        return max
    }

    // MARK: - Helpers

    private mutating func sink(_ index: Int) {
        var index = index

        while child(of: index) < storage.count {
            var childIndex = child(of: index)
            let secondChildIndex = childIndex + 1

            if secondChildIndex < storage.count && priorityFunction(storage[childIndex], storage[secondChildIndex]) {
                childIndex = secondChildIndex
            }

            if priorityFunction(storage[childIndex], storage[index]) { break }

            storage.swapAt(childIndex, index)

            index = childIndex
        }
    }

    private mutating func swim(_ index: Int) {
        var index = index
        while index > 0 && priorityFunction(storage[parent(of: index)], storage[index]) {
            storage.swapAt(parent(of: index), index)
            index = parent(of: index)
        }
    }

    private func child(of index: Int) -> Int {
        return index * 2 + 1
    }

    private func parent(of index: Int) -> Int {
        return (index - 1) / 2
    }
}
```

