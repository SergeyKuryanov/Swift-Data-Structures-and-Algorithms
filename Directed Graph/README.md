## Directed Graph

In directed graphs, edges are one-way: the pair of vertices that defines each edge is an ordered pair that specifies a one-way adjacency.

```swift
struct Digraph {
    private(set) var adjacencySet: [Set<Int>]
    private(set) var edgesCount = 0
    let verticesCount: Int

    init(verticesCount: Int) {
        self.verticesCount = verticesCount
        adjacencySet = Array(repeating: Set<Int>(), count: verticesCount)
    }

    mutating func addEdge(_ from: Int, _ to: Int) {
        adjacencySet[from].insert(to)
        edgesCount += 1
    }

    func adjacent(to vertice: Int) -> Set<Int> {
        return adjacencySet[vertice]
    }

    func reversed() -> Digraph {
        var revercedDigraph = Digraph(verticesCount: verticesCount)
        for i in 0..<verticesCount {
            for adjacent in adjacent(to: i) {
                revercedDigraph.addEdge(adjacent, i)
            }
        }

        return revercedDigraph
    }
}
```

### Graph Processing

#### Depth-first search

```swift
struct DepthFirstSearch {
    private var edgeTo: [Int]
    private var marked: [Bool]
    let source: Int

    init(graph: Digraph, vertice: Int) {
        source = vertice

        edgeTo = Array(0..<graph.verticesCount)
        marked = Array(repeating: false, count: graph.verticesCount)

        dfs(graph: graph, vertice: vertice)
    }

    private mutating func dfs(graph: Digraph, vertice: Int) {
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

```swift
struct BreadthFirstSearch {
    private var edgeTo: [Int]
    var marked: [Bool]
    let source: Int

    init(graph: Digraph, vertice: Int) {
        source = vertice
        edgeTo = Array(0..<graph.verticesCount)
        marked = Array(repeating: false, count: graph.verticesCount)
        bfs(graph: graph, vertice: vertice)
    }

    private mutating func bfs(graph: Digraph, vertice: Int) {
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

#### Cycles detection

A graph may have an exponential number of cycles so we only ask for one cycle, not all of them. For job scheduling and many other applications it is re- quired that no directed cycle exists, so digraphs where they are absent play a special role and called _directed acyclic graph_

```swift
struct DirectedCycle {
    private var marked: [Bool]
    private var stack: [Bool]
    private(set) var isCycle = false

    init(graph: Digraph) {
        marked = Array(repeating: false, count: graph.verticesCount)
        stack = Array(repeating: false, count: graph.verticesCount)

        for vertice in 0..<graph.verticesCount {
            if isCycle { return }
            if marked[vertice] { continue }
            dfs(graph: graph, vertice: vertice)
        }
    }

    private mutating func dfs(graph: Digraph, vertice: Int) {
        marked[vertice] = true
        stack[vertice] = true
        for vertice in graph.adjacent(to: vertice) {
            if isCycle { return }

            if !marked[vertice] {
                dfs(graph: graph, vertice: vertice)
            } else if stack[vertice] {
                isCycle = true
                return
            }
        }

        stack[vertice] = false
    }
}
```

#### Topological sort

Topological sort solves next problem:
> Given a set of jobs to be completed, with precedence constraints that specify that certain jobs have to be completed before certain other jobs are begun, how can we schedule the jobs such that they are all completed while still respecting the constraints?

```swift
struct DepthFirstOrder {
    private var marked: [Bool]
    private(set) var preOrder = [Int]()
    private(set) var postOrder = [Int]()

    init(graph: Digraph) {
        marked = Array(repeating: false, count: graph.verticesCount)

        for vertice in 0..<graph.verticesCount {
            if marked[vertice] { continue }
            dfs(graph: graph, vertice: vertice)
        }
    }

    private mutating func dfs(graph: Digraph, vertice: Int) {
        marked[vertice] = true
        preOrder.append(vertice)

        for vertice in graph.adjacent(to: vertice) {
            if marked[vertice] { continue }
            dfs(graph: graph, vertice: vertice)
        }

        postOrder.append(vertice)
    }
}

struct TopologicalSort {
    private(set) var order: [Int]

    init?(graph: Digraph) {
        let cycle = DirectedCycle(graph: graph)
        guard !cycle.isCycle else { return nil }

        let order = DepthFirstOrder(graph: graph)
        self.order = order.postOrder.reversed()
    }
}
```