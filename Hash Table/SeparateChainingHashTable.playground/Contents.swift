class SeparateChainingHashTable<Key: Hashable, Value> {
    class Node {
        let key: Key
        var value:  Value
        var next: Node?

        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }

    var count = 0
    var storage = Array<Node?>(repeating: nil, count: 1)

    subscript(key: Key) -> Value? {
        get {
            return get(key: key)
        }
        set(value) {
            resizeIfNeed()

            if let value = value {
                put(key: key, value: value)
            } else {
                delete(key: key)
            }
        }
    }

    private func get(key: Key) -> Value? {
        let position = self.position(for: key)

        var node = storage[position]

        while node != nil && node?.key != key {
            node = node?.next
        }

        return node?.value
    }

    private func put(key: Key, value: Value) {
        let position = self.position(for: key)

        if var node = storage[position] {
            if node.key == key {
                node.value = value
                return
            }

            while let next = node.next {
                node = next
            }

            node.next = Node(key: key, value: value)
        } else {
            storage[position] = Node(key: key, value: value)

            count += 1
        }
    }

    private func delete(key: Key) {
        guard count > 0 else { return }

        let position = self.position(for: key)

        guard let node = storage[position] else { return }

        if node.key == key {
            storage[position] = node.next

            if node.next == nil {
                count -= 1
            }
        } else {
            var beforeNode = node.next
            while beforeNode != nil && beforeNode?.key != key {
                beforeNode = beforeNode?.next
            }

            beforeNode?.next = beforeNode?.next?.next
        }
    }

    // MARK: - Helpers
    private func position(for key: Key) -> Int {
        guard storage.count > 1 else { return 0 }
        return abs(key.hashValue) % storage.count
    }

    // MARK: - Resizing
    private func resizeIfNeed() {
        if count >= storage.count / 2 {
            resizeTo(size: storage.count * 2)
        } else if count <= storage.count / 8 {
            resizeTo(size: storage.count / 2)
        }
    }

    private func resizeTo(size: Int) {
        let oldStorage = storage
        storage = Array<Node?>(repeating: nil, count: size)
        count = 0

        for var node in oldStorage {
            while node != nil {
                put(key: node!.key, value: node!.value)
                node = node?.next
            }
        }
    }
}

extension SeparateChainingHashTable: Sequence {
    struct SeparateChainingHashTableIterator: IteratorProtocol {
        private var currentIndex = 0
        private let keys: [Key]
        private let values: [Value]

        init(keys: [Key], values: [Value]) {
            self.keys = keys
            self.values = values
        }

        mutating func next() -> (Key, Value)? {
            guard currentIndex < keys.count else { return nil }
            defer { currentIndex += 1 }

            return (keys[currentIndex], values[currentIndex])
        }
    }

    func makeIterator() -> SeparateChainingHashTableIterator {
        var keys = [Key]()
        var values = [Value]()

        for var node in storage where node != nil {
            while node != nil {
                keys.append(node!.key)
                values.append(node!.value)

                node = node?.next
            }
        }
        return SeparateChainingHashTableIterator(keys: keys, values: values)
    }
}

let separateChainingHashTable = SeparateChainingHashTable<String, Int>()
separateChainingHashTable["S"] = 0
separateChainingHashTable["E"] = 1
separateChainingHashTable["A"] = 2
separateChainingHashTable["R"] = 3
separateChainingHashTable["C"] = 4
separateChainingHashTable["H"] = 5
separateChainingHashTable["E"] = 6
separateChainingHashTable["X"] = 7
separateChainingHashTable["A"] = 8
separateChainingHashTable["M"] = 9
separateChainingHashTable["P"] = 10
separateChainingHashTable["L"] = 11
separateChainingHashTable["E"] = 12

print(separateChainingHashTable.map { "\($0.0): \($0.1)" })

separateChainingHashTable["S"] = nil
separateChainingHashTable["E"] = nil
separateChainingHashTable["A"] = nil
separateChainingHashTable["R"] = nil
separateChainingHashTable["C"] = nil
separateChainingHashTable["H"] = nil
separateChainingHashTable["E"] = nil
separateChainingHashTable["X"] = nil
separateChainingHashTable["A"] = nil
separateChainingHashTable["M"] = nil
separateChainingHashTable["P"] = nil
separateChainingHashTable["L"] = nil
separateChainingHashTable["E"] = nil

print(separateChainingHashTable.map { "\($0.0): \($0.1)" })
