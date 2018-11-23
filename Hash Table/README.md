## Hash Table

Hash Table (Hash Map) is a data structure that structure that can map keys to values using hash function. The hash function depends on the key type. A hash function converts keys into array indices. The second component of a hashing algorithm is collision resolution: a strategy for handling the case when two or more keys to be inserted hash to the same index

### Separate Chaining Hash Table
 Separate Chaining Hash Table approach to collision resolution is to build, for each of the array indices, a linked list of the key-value pairs whose keys hash to that index.
 This method is known as separate chaining because items that collide are chained together in separate linked lists.

 ```swift
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
 ```

### Linear Probing Hash Table

Another approach to implementing hashing is to store N key-value pairs in a hash table of size M > N, relying on empty entries in the table to help with collision resolution. Such methods are called open-addressing hashing methods.  
The simplest open-addressing method is called linear probing: when there is a collision (when we hash to a table index that is already occupied with a key different from the search key), then we just check the next entry in the table (by incrementing the index).

```swift
class LinearProbingHashTable<Key: Hashable, Value> {
    private var count = 0
    private var keys = Array<Key?>(repeating: nil, count: 1)
    private var values = Array<Value?>(repeating: nil, count: 1)

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
        var position = self.position(for: key)

        while let currentKey = keys[position] {
            advance(&position)

            if currentKey == key {
                return values[position]
            }
        }

        return nil
    }

    private func put(key: Key, value: Value) {
        var position = self.position(for: key)

        while let currentKey = keys[position] {
            guard currentKey != key else {
                values[position] = value
                return
            }

            advance(&position)
        }

        keys[position] = key
        values[position] = value
        count += 1
    }

    private func delete(key: Key) {
        var position = self.position(for: key)

        while keys[position] != key {
            guard keys[position] != nil else { return }
            advance(&position)
        }

        while keys[position] != nil {
            let nextPosition = (position + 1) % keys.count

             keys[position] = keys[nextPosition]
             values[position] = values[nextPosition]

            position = nextPosition
        }

        keys[position] = nil
        values[position] = nil
        count -= 1
    }

    // MARK: - Helpers
    private func position(for key: Key) -> Int {
        guard keys.count > 1 else { return 0 }
        return abs(key.hashValue) % keys.count
    }

    private func advance(_ position: inout Int) {
        position = (position + 1) % keys.count
    }

    // MARK: - Resizing
    private func resizeIfNeed() {
        if count >= keys.count / 2 {
            resizeTo(size: keys.count * 2)
        } else if count <= keys.count / 8 {
            resizeTo(size: keys.count / 2)
        }
    }

    private func resizeTo(size: Int) {
        let oldKeys = keys
        let oldValues = values

        keys = Array<Key?>(repeating: nil, count: size)
        values = Array<Value?>(repeating: nil, count: size)
        count = 0

        for i in 0..<oldKeys.count {
            guard let key = oldKeys[i], let value = oldValues[i] else { continue }
            put(key: key, value: value)
        }
    }
}
```