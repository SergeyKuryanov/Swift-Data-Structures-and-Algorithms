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

struct Queue<T> {
    private var array = Array<T>()

    private var count: Int {
        return array.count
    }

    mutating func dequeue() -> T? {
        guard count > 0 else { return nil }
        return array.removeFirst()
    }

    mutating func enqueue(_ value: T) {
        array.append(value)
    }
}

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

var graph = Digraph(verticesCount: 13)
graph.addEdge(4, 2)
graph.addEdge(2, 3)
graph.addEdge(3, 2)
graph.addEdge(6, 0)
graph.addEdge(0, 1)
graph.addEdge(2, 0)
graph.addEdge(11, 12)
graph.addEdge(12, 9)
graph.addEdge(9, 10)
graph.addEdge(9, 11)
graph.addEdge(8, 9)
graph.addEdge(10, 12)
graph.addEdge(11, 4)
graph.addEdge(4, 3)
graph.addEdge(3, 5)
graph.addEdge(7, 8)
graph.addEdge(8, 7)
graph.addEdge(5, 4)
graph.addEdge(0, 5)
graph.addEdge(6, 4)
graph.addEdge(6, 9)
graph.addEdge(7, 6)

var dag = Digraph(verticesCount: 13)
dag.addEdge(2, 3)
dag.addEdge(0, 6)
dag.addEdge(0, 1)
dag.addEdge(2, 0)
dag.addEdge(11, 12)
dag.addEdge(9, 12)
dag.addEdge(9, 10)
dag.addEdge(9, 11)
dag.addEdge(3, 5)
dag.addEdge(8, 7)
dag.addEdge(5, 4)
dag.addEdge(0, 5)
dag.addEdge(6, 4)
dag.addEdge(6, 9)
dag.addEdge(7, 6)

let dfs = DepthFirstSearch(graph: graph, vertice: 0)
dfs.path(to: 3)
dfs.path(to: 10)

let bfs = BreadthFirstSearch(graph: graph, vertice: 0)
bfs.path(to: 3)
bfs.path(to: 10)

var cycle = DirectedCycle(graph: graph)
cycle.isCycle

cycle = DirectedCycle(graph: dag)
cycle.isCycle

let order = DepthFirstOrder(graph: dag)
order.preOrder
order.postOrder

TopologicalSort(graph: graph)?.order
TopologicalSort(graph: dag)?.order
