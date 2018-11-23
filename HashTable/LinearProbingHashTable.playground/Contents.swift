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

extension LinearProbingHashTable: Sequence {
    struct LinearProbingHashTableIterator: IteratorProtocol {
        private var currentIndex = 0
        private let keys: [Key?]
        private let values: [Value?]

        init(keys: [Key?], values: [Value?]) {
            self.keys = keys
            self.values = values
        }

        mutating func next() -> (Key, Value)? {
            guard currentIndex < keys.count else { return nil }
            defer { currentIndex += 1 }

            while keys[currentIndex] == nil {
                currentIndex += 1
                if currentIndex >= keys.count { return nil }
            }

            guard let key = keys[currentIndex], let value = values[currentIndex] else { return nil }

            return (key, value)
        }
    }

    func makeIterator() -> LinearProbingHashTableIterator {
        return LinearProbingHashTableIterator(keys: keys, values: values)
    }
}

let linearProbingHashTable = LinearProbingHashTable<String, Int>()
linearProbingHashTable["A"] = nil

linearProbingHashTable["S"] = 0
linearProbingHashTable["E"] = 1
linearProbingHashTable["A"] = 2
linearProbingHashTable["R"] = 3
linearProbingHashTable["C"] = 4
linearProbingHashTable["H"] = 5
linearProbingHashTable["E"] = 6
linearProbingHashTable["X"] = 7
linearProbingHashTable["A"] = 8
linearProbingHashTable["M"] = 9
linearProbingHashTable["P"] = 10
linearProbingHashTable["L"] = 11
linearProbingHashTable["E"] = 12

print(linearProbingHashTable.map { "\($0.0): \($0.1)" })

linearProbingHashTable["S"] = nil
linearProbingHashTable["E"] = nil
linearProbingHashTable["A"] = nil
linearProbingHashTable["R"] = nil
linearProbingHashTable["C"] = nil
linearProbingHashTable["H"] = nil
linearProbingHashTable["E"] = nil
linearProbingHashTable["X"] = nil
linearProbingHashTable["A"] = nil
linearProbingHashTable["M"] = nil
linearProbingHashTable["P"] = nil
linearProbingHashTable["L"] = nil
linearProbingHashTable["E"] = nil

print(linearProbingHashTable.map { "\($0.0): \($0.1)" })
