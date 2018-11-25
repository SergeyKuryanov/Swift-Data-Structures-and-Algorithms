## Undirected Graph

A graph is a set of vertices and a collection of edges that each connect a pair of vertices.  
Graph can be represented in few ways:
- Adjacency matrix  
N by N boolean array, where i, j represents connection between vertices
- Adjacency list  
Array of lists, which represents connected vertices to index edge
- Adjacency Set
Arrya of sets, which represents connected vertices to index edge

Adjacency Set implementation:

```swift
struct Graph {
    private(set) var adjacencySet: [Set<Int>]
    private(set) var edgesCount = 0
    let verticesCount: Int

    init(verticesCount: Int) {
        self.verticesCount = verticesCount
        adjacencySet = Array(repeating: Set<Int>(), count: verticesCount)
    }

    mutating func addEdge(_ from: Int, _ to: Int) {
        adjacencySet[from].insert(to)
        adjacencySet[to].insert(from)
        edgesCount += 1
    }

    func adjacent(to vertice: Int) -> Set<Int> {
        return adjacencySet[vertice]
    }
}
```

### Graph Processing

#### Depth-first search

The classic recursive method for searching in a connected graph (visiting all of its vertices and edges) mimics Tremaux maze exploration but is even simpler to describe. To search a graph, invoke a recursive method that visits vertices. To visit a vertex:
- Mark it as having been visited.
- Visit (recursively) all the vertices that are adjacent to it and that have not yet been marked.

```swift
struct DepthFirstSearch {
    private var edgeTo: [Int]
    private var marked: [Bool]
    let source: Int

    init(graph: Graph, vertice: Int) {
        source = vertice

        edgeTo = Array(0..<graph.verticesCount)
        marked = Array(repeating: false, count: graph.verticesCount)

        dfs(graph: graph, vertice: vertice)
    }

    private mutating func dfs(graph: Graph, vertice: Int) {
        marked[vertice] = true
        graph.adjacent(to: vertice).forEach {
            if marked[$0] { return }
            edgeTo[$0] = vertice
            dfs(graph: graph, vertice: $0)
        }
    }

    func hasPath(to vertice: Int) -> Bool {
        return marked[vertice]
    }

    func path(to vertice: Int) -> [Int]? {
        guard hasPath(to: vertice) else { return nil }

        var current = vertice
        var path = [Int]()

        while current != source {
            path.append(current)
            current = edgeTo[current]
        }

        return path.reversed()
    }
}
```

#### Breadth-first search

Unline DFS, BFS examines adjacent nodes first, before moving to next level. We use queue for that. 

```swift
struct BreadthFirstSearch {
    private var edgeTo: [Int]
    var marked: [Bool]
    let source: Int

    init(graph: Graph, vertice: Int) {
        source = vertice
        edgeTo = Array(0..<graph.verticesCount)
        marked = Array(repeating: false, count: graph.verticesCount)
        bfs(graph: graph, vertice: vertice)
    }

    private mutating func bfs(graph: Graph, vertice: Int) {
        var queue = Queue<Int>()

        marked[vertice] = true
        queue.enqueue(vertice)

        while let vertice = queue.dequeue() {
            graph.adjacent(to: vertice).forEach {
                if marked[$0] { return }

                marked[$0] = true
                edgeTo[$0] = vertice

                queue.enqueue($0)
            }
        }

    }

    func hasPath(to vertice: Int) -> Bool {
        return marked[vertice]
    }

    func path(to vertice: Int) -> [Int]? {
        guard hasPath(to: vertice) else { return nil }

        var current = vertice
        var path = [Int]()

        while current != source {
            path.append(current)
            current = edgeTo[current]
        }

        return path.reversed()
    }
}
```

#### Connected components

As an example of using DFS - find the connected components of a graph. In theory CC faster than union-find, but in practice union-find faster because does not required to build full representation of graph and in mixed operations.

```swift
struct ConnectedComponents {
    private var marked: [Int]
    var count: Int = 0

    init(graph: Graph) {
        marked = Array(repeating: -1, count: graph.verticesCount)
        for vertice in 0..<graph.verticesCount {
            guard marked[vertice] < 0 else { continue }

            dfs(graph: graph, vertice: vertice)
            count += 1
        }
    }

    private mutating func dfs(graph: Graph, vertice: Int) {
        marked[vertice] = count

        for vertice in graph.adjacent(to: vertice) {
            guard marked[vertice] < 0 else { continue }
            dfs(graph: graph, vertice: vertice)
        }
    }

    func group(for vertice: Int) -> Int {
        return marked[vertice]
    }
}
```

#### Cycle detection

```swift
struct Cycle {
    private var marked: [Bool]
    var isCycle = false

    init(graph: Graph) {
        marked = Array(repeating: false, count: graph.verticesCount)

        for vertice in 0..<graph.verticesCount {
            if isCycle { return }
            if marked[vertice] { continue }
            dfs(graph: graph, vertice: vertice, source: vertice)
        }
    }

    private mutating func dfs(graph: Graph, vertice: Int, source: Int) {
        marked[vertice] = true

        for current in graph.adjacent(to: vertice) {
            if marked[current] {
                if current != source {
                    isCycle = true
                    return
                }
            } else {
                dfs(graph: graph, vertice: current, source: vertice)
            }
        }
    }
}
```