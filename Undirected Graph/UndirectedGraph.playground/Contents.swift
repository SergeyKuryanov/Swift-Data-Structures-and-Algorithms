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

var graph = Graph(verticesCount: 13)
graph.addEdge(0, 5)
graph.addEdge(4, 3)
graph.addEdge(0, 1)
graph.addEdge(9, 12)
graph.addEdge(6, 4)
graph.addEdge(5, 4)
graph.addEdge(0, 2)
graph.addEdge(11, 12)
graph.addEdge(9, 10)
graph.addEdge(0, 6)
graph.addEdge(7, 8)
graph.addEdge(9, 11)
graph.addEdge(5, 3)

var dfs = DepthFirstSearch(graph: graph, vertice: 0)
dfs.path(to: 3)
dfs.path(to: 10)

var bfs = BreadthFirstSearch(graph: graph, vertice: 0)
bfs.path(to: 3)
bfs.path(to: 10)

var cc = ConnectedComponents(graph: graph)
cc.group(for: 0)
cc.group(for: 3)
cc.group(for: 7)
cc.group(for: 9)

var cycle = Cycle(graph: graph)
cycle.isCycle

graph = Graph(verticesCount: 2)
graph.addEdge(0, 1)
cycle = Cycle(graph: graph)
cycle.isCycle
