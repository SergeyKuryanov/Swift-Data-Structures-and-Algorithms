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

extension BinarySearchSymbolTable: CustomStringConvertible {
    var description: String {
        return keys.description + "\n" + values.description
    }
}

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

var binarySearchST = BinarySearchSymbolTable<String, Int>()
binarySearchST["S"] = 0
binarySearchST["E"] = 1
binarySearchST["A"] = 2
binarySearchST["R"] = 3
binarySearchST["C"] = 4
binarySearchST["H"] = 5
binarySearchST["E"] = 6
binarySearchST["X"] = 7
binarySearchST["A"] = 8
binarySearchST["M"] = 9
binarySearchST["P"] = 10
binarySearchST["L"] = 11
binarySearchST["E"] = 12

for (key, value) in binarySearchST {
    print("key: \(key), value:\(value)")
}

binarySearchST["A"]
binarySearchST["S"]
binarySearchST["Y"]

binarySearchST["S"] = nil
binarySearchST["E"] = nil
binarySearchST["A"] = nil
binarySearchST["R"] = nil
binarySearchST["C"] = nil
binarySearchST["H"] = nil
binarySearchST["E"] = nil
binarySearchST["X"] = nil
binarySearchST["A"] = nil
binarySearchST["M"] = nil
binarySearchST["P"] = nil
binarySearchST["L"] = nil
binarySearchST["E"] = nil
print(binarySearchST)
