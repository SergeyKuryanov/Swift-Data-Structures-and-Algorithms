## Union-Find

Union-Find (disjoint-set, merge–find set) data structure, is a data structure that keeps track of a set of elements partitioned into a number of disjoint (non-overlapping) subsets.
Useful to solve Dynamic Connectivity Problems, Percolation, Games, Image Processing.


### Quick-Find

Initialize | Union | Find
:--------: | :---: | :-:
O(n)       | O(n)  | O(1)


Quick-find defect:
* Union too expensive (N array accesses).
* Trees are flat, but too expensive to keep them flat.

```swift
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
```

### Quick-Union

Initialize | Union | Find
:--------: | :---: | :-:
O(n)       | O(n)  | O(n)


Quick-union defect:
* Trees can get tall.
* Find too expensive (could be N array accesses).


```swift
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
```

### Weighted Quick Union

Initialize |  Union  |  Find
:--------: | :-----: | :-----:
O(n)       | O(ln n) | O(ln n)

Weighted Quick-union defect:
* Trees can get tall

```swift
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
```

### Weighted Quick-Union With Path Compression

Initialize |          Union           |          Find
:--------: | :----------------------: | :----------------------:
O(n)       | Very close, but not O(1) | Very close, but not O(1)


```swift
class WeightedQuickUnionWithPathCompression: WeightedQuickUnion {
    override func root(of node: Int) -> Int {
        var node = node

        while node != storage[node] {
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
```
