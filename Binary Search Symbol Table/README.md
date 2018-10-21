## Binary Search Symbol Table

The primary purpose of a symbol table is to associate a value with a key. The client can insert key-value pairs into the symbol table with the expectation of later being able to search for the value associated with a given key, from among all of the key-value pairs that have been put into the table. Binary Search Symbol Table uses binary serch to read values, which is stored in ordered array of keys.

Insert | Read      | Delete
:----: | :-------: | :----:
O(n)   | O(log(n)) | O(n)

```swift
struct BinarySearchSymbolTable<Key: Comparable, Value: Equatable> {
    private var keys = [Key]()
    private var values = [Value]()

    var count: Int {
        return keys.count
    }

    subscript(key: Key) -> Value? {
        get {
            return get(key: key)
        }
        set(value) {
            guard let value = value else {
                delete(key: key)
                return
            }

            put(key: key, value: value)
        }
    }

    // MARK: - Helpers
    private mutating func put(key: Key, value: Value) {
        let position = rank(key: key)

        if position < count - 1 && keys[position] == key {
            values[position] = value
        } else {
            keys.append(key)
            values.append(value)

            for i in stride(from: count - 1, to: position, by: -1) {
                keys[i] = keys[i - 1]
                values[i] = values[i - 1]
            }

            keys[position] = key
            values[position] = value
        }
    }

    private func get(key: Key) -> Value? {
        guard count > 0 else { return nil }

        let position = rank(key: key)
        guard position < count && keys[position] == key else { return nil }
        return values[position]
    }

    private mutating func delete(key: Key) {
        guard count > 0 else { return }

        let position = rank(key: key)
        guard keys[position] == key else { return }

        for i in position..<count - 1 {
            keys[i] = keys[i + 1]
            values[i] = values[i + 1]
        }

        keys.removeLast()
        values.removeLast()
    }

    private func rank(key: Key) -> Int {
        var lo = 0
        var hi = count - 1

        while lo <= hi {
            let mid = lo + (hi - lo) / 2

            if keys[mid] > key {
                hi = mid - 1
            } else if keys[mid] < key {
                lo = mid + 1
            } else {
                return mid
            }
        }

        return lo
    }
}
```

It is useful to be able to iterage trought values of symbol table:

```swift
extension BinarySearchSymbolTable: Sequence {
    struct BinarySearchSymbolTableItetator: IteratorProtocol {
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

    func makeIterator() -> BinarySearchSymbolTableItetator {
        return BinarySearchSymbolTableItetator(keys: keys, values: values)
    }
}
```