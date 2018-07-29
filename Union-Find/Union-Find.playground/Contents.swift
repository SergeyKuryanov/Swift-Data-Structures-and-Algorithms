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

        guard pRoot != qRoot else { return }

        storage = storage.map { $0 == pRoot ? qRoot : $0 }
    }
}

extension QuickFind: CustomStringConvertible {
    var description: String {
        return "\(storage)"
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

extension QuickUnion: CustomStringConvertible {
    var description: String {
        return "\(storage)"
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
        var node = node

        while (node != storage[node]) {
            storage[node] = storage[storage[node]]
            node = storage[node]
        }

        return node
    }

    override func rootRecursive(of node: Int) -> Int {
        let nodeRoot = storage[node]

        guard nodeRoot != node else { return node }

        storage[node] = storage[nodeRoot]

        return root(of: nodeRoot)
    }
}

var qf = QuickFind(count: 10)
qf.union(p: 9, q: 0)
qf.union(p: 3, q: 4)
qf.union(p: 5, q: 8)
qf.union(p: 7, q: 2)
qf.union(p: 2, q: 1)
qf.union(p: 5, q: 7)
qf.union(p: 0, q: 3)
qf.union(p: 4, q: 2)

var uf = QuickUnion(count: 10)
uf.union(p: 9, q: 0)
uf.union(p: 3, q: 4)
uf.union(p: 5, q: 8)
uf.union(p: 7, q: 2)
uf.union(p: 2, q: 1)
uf.union(p: 5, q: 7)
uf.union(p: 0, q: 3)
uf.union(p: 4, q: 2)

uf = WeightedQuickUnion(count: 10)
uf.union(p: 9, q: 0)
uf.union(p: 3, q: 4)
uf.union(p: 5, q: 8)
uf.union(p: 7, q: 2)
uf.union(p: 2, q: 1)
uf.union(p: 5, q: 7)
uf.union(p: 0, q: 3)
uf.union(p: 4, q: 2)

uf = WeightedQuickUnionWithPathCompression(count: 10)
uf.union(p: 9, q: 0)
uf.union(p: 3, q: 4)
uf.union(p: 5, q: 8)
uf.union(p: 7, q: 2)
uf.union(p: 2, q: 1)
uf.union(p: 5, q: 7)
uf.union(p: 0, q: 3)
uf.union(p: 4, q: 2)
