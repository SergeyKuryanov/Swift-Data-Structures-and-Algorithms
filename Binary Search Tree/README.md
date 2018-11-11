## Binary Search Table

A binary search tree (BST) is a binary tree where each node has a key (and an associated value) and satisfies the restriction that the key in any node is larger than the keys in all nodes in that node’s left subtree and small- er than the keys in all nodes in that node’s right subtree.

Insert | Read   | Delete | Size | Height
:----: | :----: | :----: | :--: | :----:
O(n)   | O(n)   | O(n)   | O(1) | O(n)

```swift
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
```