struct BagArray<Item> {
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

extension BagArray: Sequence, IteratorProtocol {
    mutating func next() -> Item? {
        guard current < storage.count else { return nil }

        defer { current += 1 }
        return storage[current]
    }
}


var bagArray = BagArray<Int>()
bagArray.isEmpty
bagArray.add(1)
bagArray.add(2)
bagArray.add(3)
bagArray.isEmpty
bagArray.add(4)
bagArray.add(5)
bagArray.count

for item in bagArray {
    print(item)
}

class BagLinkedList<T> {
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

extension BagLinkedList: Sequence, IteratorProtocol {
    func next() -> T? {
        guard let item = currentItem else { return nil }
        currentItem = item.next

        return item.value
    }
}

var bagLinkedList = BagLinkedList<Int>()
bagLinkedList.isEmpty
bagLinkedList.add(1)
bagLinkedList.add(2)
bagLinkedList.add(3)
bagLinkedList.isEmpty
bagLinkedList.add(4)
bagLinkedList.add(5)
bagLinkedList.count

for item in bagLinkedList {
    print(item)
}

