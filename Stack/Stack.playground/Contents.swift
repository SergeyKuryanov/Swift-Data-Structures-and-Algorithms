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

struct LinkedListStack<T> {
    private let linkedList = LinkedList<T>()

    mutating func pop() -> T? {
        return linkedList.removeHead()?.value
    }

    mutating func push(_ value: T) {
        linkedList.appendHead(value)
    }

    func peek() -> T? {
        return linkedList.head?.value
    }
}

extension LinkedListStack: CustomStringConvertible {
    public var description: String {
        return linkedList.description
    }
}

var linkedListStack = LinkedListStack<Int>()
linkedListStack.push(0)
linkedListStack.push(1)
linkedListStack.push(2)
linkedListStack.pop()
linkedListStack.pop()
linkedListStack.push(3)
linkedListStack.push(4)
linkedListStack.pop()
linkedListStack.push(5)
linkedListStack.peek()

struct ArrayStack<T> {
    private var array = Array<T>()
    var count: Int {
        return array.count
    }

    mutating func pop() -> T {
        return array.removeLast()
    }

    mutating func push(_ value: T) {
        array.append(value)
    }

    func peek() -> T? {
        return array.last
    }
}

extension ArrayStack: Sequence {
    struct StackItetator: IteratorProtocol {
        private var elements: [T]

        init(elements: [T]) {
            self.elements = elements
        }

        mutating func next() -> T? {
            guard !elements.isEmpty else { return nil }
            return elements.popLast()
        }
    }

    func makeIterator() -> StackItetator {
        return StackItetator(elements: array)
    }
}

extension ArrayStack: CustomStringConvertible {
    public var description: String {
        return "count: \(count), \(array.compactMap { $0 })"
    }
}

var arrayStack = ArrayStack<Int>()
arrayStack.push(0)
arrayStack.push(1)
arrayStack.push(2)
arrayStack.pop()
arrayStack.pop()
arrayStack.push(3)
arrayStack.push(4)
arrayStack.pop()
arrayStack.push(5)
arrayStack.peek()

for element in arrayStack {
    print(element)
}

struct ResizableArrayStack<T> {
    private var array = Array<T?>(repeating: nil, count: 1)
    private var count = 0

    mutating func pop() -> T? {
        defer {
            resizeIfNeed()
        }
        count -= 1
        return array[count]
    }

    mutating func push(_ value: T) {
        array[count] = value
        count += 1
        resizeIfNeed()
    }

    func peek() -> T? {
        return array[count - 1]
    }

    mutating private func resizeIfNeed() {
        if count == array.count {
            resizeTo(size: count * 2)
        } else if count <= array.count / 4 {
            resizeTo(size: array.count / 2)
        }
    }

    mutating private func resizeTo(size: Int) {
        var newArray = Array<T?>(repeating: nil, count: size)
        newArray[0..<count] = array[0..<count]
        array = newArray
    }
}

extension ResizableArrayStack: CustomStringConvertible {
    public var description: String {
        return "count: \(count), \(array.compactMap { $0 })"
    }
}

var resizableArrayStack = ResizableArrayStack<Int>()
resizableArrayStack.push(0)
resizableArrayStack.push(1)
resizableArrayStack.push(2)
resizableArrayStack.pop()
resizableArrayStack.pop()
resizableArrayStack.push(3)
resizableArrayStack.push(4)
resizableArrayStack.pop()
resizableArrayStack.push(5)
resizableArrayStack.peek()

