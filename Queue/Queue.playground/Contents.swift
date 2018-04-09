import Foundation

class LinkedList<T> {
    typealias ListNode = Node<T>

    class Node<T>: CustomStringConvertible {
        var next: Node<T>?
        var prev: Node<T>?
        let value: T

        init(_ value: T) {
            self.value = value
        }

        public var description: String {
            return String(describing: value)
        }
    }

    var head: ListNode?
    var tail: ListNode?

    func isEmpty() -> Bool {
        return head == nil
    }

    func appendHead(_ value: T) {
        let newNode = ListNode(value)
        newNode.next = head
        head = newNode

        if tail == nil {
            tail = head
        }
    }

    func appendTail(_ value: T) {

        let newNode = ListNode(value)
        tail?.next = newNode
        newNode.prev = tail
        tail = newNode

        if head == nil {
            head = tail
        }
    }

    func removeHead() -> ListNode? {
        if head == nil && tail != nil {
            return removeTail()
        }

        let headNode = head
        head = head?.next
        head?.prev = nil

        return headNode
    }

    func removeTail() -> ListNode? {
        if tail == nil && head != nil {
            return removeHead()
        }

        let tailNode = tail
        tail = tailNode?.prev
        tail?.next = nil

        if tail == nil {
            head?.next = nil
        }

        return tailNode
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        var desc = "["
        var node = head
        while node != nil {
            desc += "\(node!.value)"
            node = node?.next
            if node != nil { desc += ", " }
        }
        return desc + "]"
    }
}

struct LinkedListQueue<T> {
    private let linkedList = LinkedList<T>()

    mutating func dequeue() -> T? {
        return linkedList.removeHead()?.value
    }

    mutating func enqueue(_ value: T) {
        linkedList.appendTail(value)
    }
}

extension LinkedListQueue: CustomStringConvertible {
    public var description: String {
        return linkedList.description
    }
}

var linkedListQueue = LinkedListQueue<Int>()
linkedListQueue.enqueue(1)
linkedListQueue.enqueue(2)
linkedListQueue.dequeue()
linkedListQueue.enqueue(3)
linkedListQueue.enqueue(4)
linkedListQueue.dequeue()
linkedListQueue.dequeue()
linkedListQueue.enqueue(5)
linkedListQueue.dequeue()

struct ArrayQueue<T> {
    private var array = Array<T>()
    private var count: Int {
        return array.count
    }

    mutating func dequeue() -> T? {
        return array.removeFirst()
    }

    mutating func enqueue(_ value: T) {
        array.append(value)
    }
}

extension ArrayQueue: Sequence {
    struct QueueItetator: IteratorProtocol {
        private var elements: [T]

        init(elements: [T]) {
            self.elements = elements
        }

        mutating func next() -> T? {
            guard !elements.isEmpty else { return nil }
            return elements.removeFirst()
        }
    }

    func makeIterator() -> QueueItetator {
        return QueueItetator(elements: array)
    }
}

extension ArrayQueue: CustomStringConvertible {
    public var description: String {
        return "count: \(count), \(array.compactMap { $0 })"
    }
}

var arrayQueue = ArrayQueue<Int>()
arrayQueue.enqueue(1)
arrayQueue.enqueue(2)
arrayQueue.dequeue()
arrayQueue.enqueue(3)
arrayQueue.enqueue(4)
arrayQueue.dequeue()
arrayQueue.dequeue()
arrayQueue.enqueue(5)
arrayQueue.dequeue()

for element in arrayQueue {
    print(element)
}

struct ResizableArrayQueue<T> {
    private var array = Array<T?>(repeating: nil, count: 1)
    private var headIndex = 0
    private var tailIndex = 0
    private var count: Int {
        return tailIndex - headIndex
    }

    mutating func dequeue() -> T? {
        guard count > 0 else { return nil }

        defer {
            array[headIndex] = nil
            headIndex += 1
            resizeIfNeed()
        }

        return array[headIndex]
    }

    mutating func enqueue(_ value: T) {
        array[tailIndex] = value
        tailIndex += 1
        resizeIfNeed()
    }

    mutating private func resizeIfNeed() {
        if tailIndex >= array.count {
            resizeTo(size: count * 2)
        } else if count <= array.count / 4 {
            resizeTo(size: array.count / 2)
        }
    }

    mutating private func resizeTo(size: Int) {
        var newArray = Array<T?>(repeating: nil, count: size)
        newArray[0..<count] = array[headIndex..<tailIndex]
        array = newArray
        tailIndex = count
        headIndex = 0
    }
}

extension ResizableArrayQueue: CustomStringConvertible {
    public var description: String {
        return "count: \(count), \(array.compactMap { $0 })"
    }
}

var resizableArrayQueue = ResizableArrayQueue<Int>()
resizableArrayQueue.enqueue(1)
resizableArrayQueue.enqueue(2)
resizableArrayQueue.dequeue()
resizableArrayQueue.enqueue(3)
resizableArrayQueue.enqueue(4)
resizableArrayQueue.dequeue()
resizableArrayQueue.dequeue()
resizableArrayQueue.enqueue(5)
resizableArrayQueue.dequeue()

struct RandomizedQueue<T> {
    private var array = Array<T?>(repeating: nil, count: 1)
    private var headIndex = 0
    private var tailIndex = 0
    private var count: Int {
        return tailIndex - headIndex
    }

    mutating func dequeue() -> T? {
        guard count > 0 else { return nil }

        let randomIndex = Int(arc4random_uniform(UInt32(count))) + headIndex

        array.swapAt(headIndex, randomIndex)

        defer {
            array[headIndex] = nil
            headIndex += 1
            resizeIfNeed()
        }

        return array[headIndex]
    }

    mutating func enqueue(_ value: T) {
        array[tailIndex] = value
        tailIndex += 1
        resizeIfNeed()
    }

    mutating private func resizeIfNeed() {
        if tailIndex >= array.count {
            resizeTo(size: count * 2)
        } else if count <= array.count / 4 {
            resizeTo(size: array.count / 2)
        }
    }

    mutating private func resizeTo(size: Int) {
        var newArray = Array<T?>(repeating: nil, count: size)
        newArray[0..<count] = array[headIndex..<tailIndex]
        array = newArray
        tailIndex = count
        headIndex = 0
    }
}

extension RandomizedQueue: Sequence {
    struct QueueItetator: IteratorProtocol {
        private var queue: RandomizedQueue

        init(queue: RandomizedQueue) {
            self.queue = queue
        }

        mutating func next() -> T? {
            return queue.dequeue()
        }
    }

    func makeIterator() -> QueueItetator {
        return QueueItetator(queue: self)
    }
}

extension RandomizedQueue: CustomStringConvertible {
    public var description: String {
        return "count: \(count), \(array.compactMap { $0 })"
    }
}

var randomizedQueue = RandomizedQueue<Int>()
randomizedQueue.enqueue(1)
randomizedQueue.enqueue(2)
randomizedQueue.enqueue(3)
randomizedQueue.enqueue(4)
randomizedQueue.enqueue(5)
randomizedQueue.enqueue(6)
randomizedQueue.enqueue(7)
randomizedQueue.enqueue(8)
randomizedQueue.enqueue(9)

for value in randomizedQueue {
    print(value)
}

randomizedQueue.dequeue()
randomizedQueue.dequeue()
randomizedQueue.dequeue()
randomizedQueue.dequeue()
randomizedQueue.dequeue()
randomizedQueue.dequeue()
randomizedQueue.dequeue()
randomizedQueue.dequeue()
