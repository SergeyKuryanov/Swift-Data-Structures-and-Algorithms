struct BinarySearchTree<Key: Comparable, Value> {
    class Node {
        let key: Key
        var value: Value
        var left: Node?
        var right: Node?
        var size = 1

        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }

    private var root: Node?

    var height: Int { return height(root) }
    var size: Int { return size(root) }

    subscript(key: Key) -> Value? {
        get {
            return get(key: key)
        }
        set(value) {
            guard let value = value else {
                root = delete(key: key, node: root)
                return
            }

            put(key: key, value: value)
        }
    }

    var min: Node? {
        guard let root = root else { return nil }
        return min(node: root)
    }

    var max: Node? {
        guard let root = root else { return nil }
        return max(node: root)
    }

    mutating func deleteMin() {
        root = deleteMin(node: root)
    }

    mutating func deleteMax() {
        root = deleteMax(node: root)
    }

    // MARK: - Helpers
    private func size(_ node: Node?) -> Int {
        guard let node = node else { return 0 }
        return node.size
    }

    private func get(key: Key) -> Value? {
        return get(key: key, node: root)
    }

    private func get(key: Key, node: Node?) -> Value? {
        guard let node = node else { return nil }

        if key > node.key { return get(key: key, node: node.right) }
        else if key < node.key { return get(key: key, node: node.left) }
        else { return node.value }
    }

    private mutating func put(key: Key, value: Value) {
        root = put(key: key, value: value, node: root)
    }

    private mutating func put(key: Key, value: Value, node: Node?) -> Node {
        guard let node = node else { return Node(key: key, value: value) }

        if key > node.key { node.right = put(key: key, value: value, node: node.right) }
        else if key < node.key { node.left = put(key: key, value: value, node: node.left) }
        else { node.value = value }

        node.size = size(node.left) + size(node.right) + 1

        return node
    }

    private func min(node: Node) -> Node {
        guard let left = node.left else { return node }
        return min(node: left)
    }

    private func max(node: Node) -> Node {
        guard let right = node.right else { return node }
        return max(node: right)
    }

    private mutating func deleteMin(node: Node?) -> Node? {
        guard let node = node else { return nil }
        guard let left = node.left else { return node.right }
        node.left = deleteMin(node: left)
        node.size = size(node.left) + size(node.right) + 1

        return node
    }

    private mutating func deleteMax(node: Node?) -> Node? {
        guard let node = node else { return nil }
        guard let right = node.right else { return node.right }
        node.right = deleteMax(node: right)
        node.size = size(node.left) + size(node.right) + 1

        return node
    }

    private mutating func delete(key: Key, node: Node?) -> Node? {
        guard var node = node else { return nil }

        if key > node.key { node.right = delete(key: key, node: node.right) }
        else if key < node.key { node.left = delete(key: key, node: node.left) }
        else {
            guard let right = node.right else { return node.left }
            guard let left = node.left else { return node.right }

            node = min(node: right)
            node.right = deleteMin(node: right)
            node.left = left
        }

        node.size = size(node.left) + size(node.right) + 1
        return node
    }

    private func height(_ node: Node?) -> Int {
        guard let node = node else { return 0 }
        return Swift.max(height(node.left), height(node.right)) + 1
    }
}

extension BinarySearchTree: Sequence {
    struct BinarySearchTreeItetator: IteratorProtocol {
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

    func makeIterator() -> BinarySearchTreeItetator {
        var keys = [Key]()
        var values = [Value]()
        emit(node: root, keys: &keys, values: &values)
        return BinarySearchTreeItetator(keys: keys, values: values)
    }

    private func emit(node: Node?, keys: inout [Key], values: inout [Value]) {
        guard let node = node else { return }
        emit(node: node.left, keys: &keys, values: &values)
        keys.append(node.key)
        values.append(node.value)
        emit(node: node.right, keys: &keys, values: &values)
    }
}

var binarySearchTree = BinarySearchTree<String, Int>()
binarySearchTree["S"] = 0
binarySearchTree["E"] = 1
binarySearchTree["A"] = 2
binarySearchTree["R"] = 3
binarySearchTree["C"] = 4
binarySearchTree["H"] = 5
binarySearchTree["E"] = 6
binarySearchTree["X"] = 7
binarySearchTree["A"] = 8
binarySearchTree["M"] = 9
binarySearchTree["P"] = 10
binarySearchTree["L"] = 11
binarySearchTree["E"] = 12

binarySearchTree.size

binarySearchTree.min?.key
binarySearchTree.max?.key

binarySearchTree.deleteMin()
binarySearchTree.deleteMax()

binarySearchTree.min?.key
binarySearchTree.max?.key

binarySearchTree.height

binarySearchTree["S"] = nil
binarySearchTree["S"]

binarySearchTree.height

for (key, value) in binarySearchTree {
    print("\(key) - \(value)")
}
