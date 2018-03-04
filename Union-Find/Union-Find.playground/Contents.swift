class QuickFind {
    var storage = [Int]()

    init(count: Int) {
        storage += 0..<count
    }

    func isConnected(p: Int, q: Int) -> Bool {
        return storage[p] == storage[q]
    }

    func union(p: Int, q: Int) {
        let pRoot = storage[p]
        let qRoot = storage[q]

        storage = storage.map { $0 == pRoot ? qRoot : $0 }
    }
}

class QuickUnion {
    var storage = [Int]()

    init(count: Int) {
        storage += 0..<count
    }

    func isConnected(p: Int, q: Int) -> Bool {
        return root(of: p) == root(of: q)
    }

    func union(p: Int, q: Int) {
        let pRoot = root(of: p)
        let qRoot = root(of: q)

        storage[pRoot] = qRoot
    }

    func root(of node: Int) -> Int {
        var node = node

        while (node != storage[node]) {
            node = storage[node]
        }
        
        return node
    }

    func rootRecursive(of node: Int) -> Int {
        let nodeRoot = storage[node]
        guard nodeRoot != node else { return node }

        return root(of: nodeRoot)
    }
}

class WeightedQuickUnion: QuickUnion {
    var sizes = [Int]()

    override init(count: Int) {
        sizes = Array(repeating: 0, count: count)
        super.init(count: count)
    }

    override func union(p: Int, q: Int) {
        let pRoot = root(of: p)
        let qRoot = root(of: q)

        guard pRoot != qRoot else { return }

        let pSize = sizes[pRoot]
        let qSize = sizes[qRoot]

        if pSize < qSize {
            storage[pRoot] = qRoot
            sizes[qRoot] += pSize
        } else {
            storage[qRoot] = pRoot
            sizes[pRoot] += qSize
        }
    }
}

class WeightedQuickUnionWithPathCompression: WeightedQuickUnion {
    override func root(of node: Int) -> Int {
        let nodeRoot = storage[node]

        guard nodeRoot != node else { return node }

        storage[node] = storage[nodeRoot]

        return root(of: nodeRoot)
    }

    override func rootRecursive(of node: Int) -> Int {
        var node = node

        while (node != storage[node]) {
            storage[node] = storage[storage[node]]
            node = storage[node]
        }

        return node
    }
}
