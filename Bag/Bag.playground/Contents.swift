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


var arrayBag = ArrayBag<Int>()
arrayBag.isEmpty
arrayBag.add(1)
arrayBag.add(2)
arrayBag.add(3)
arrayBag.isEmpty
arrayBag.add(4)
arrayBag.add(5)
arrayBag.count

for item in arrayBag {
    print(item)
}

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

var linkedListBag = LinkedListBag<Int>()
linkedListBag.isEmpty
linkedListBag.add(1)
linkedListBag.add(2)
linkedListBag.add(3)
linkedListBag.isEmpty
linkedListBag.add(4)
linkedListBag.add(5)
linkedListBag.count

for item in linkedListBag {
    print(item)
}

