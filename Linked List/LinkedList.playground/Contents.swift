class LinkedList<T> {
    typealias ListNode = Node<T>

    class Node<T>: CustomStringConvertible {
        var next: Node<T>?
        let value: T

        init(_ value: T) {
            self.value = value
        }

        public var description: String {
            return String(describing: value)
        }
    }

    var head: ListNode?
    var tail: ListNode? {
        guard var node = head else { return nil }

        while let next = node.next {
            node = next
        }

        return node
    }

    func isEmpty() -> Bool {
        return head == nil
    }

    func appendHead(_ value: T) {
        let newNode = ListNode(value)
        newNode.next = head
        head = newNode
    }

    func appendTail(_ value: T) {
        let newNode = ListNode(value)
        if let tail = tail {
            tail.next = newNode
        } else {
            head = newNode
        }
    }

    func removeHead() -> ListNode? {
        let headNode = head
        head = head?.next
        
        return headNode
    }

    func removeTail() -> ListNode? {
        guard var node = head else { return nil }

        if node.next == nil {
            head = nil
            return node
        }

        while let next = node.next, next.next != nil {
            node = next
        }

        let tailNode = node.next
        node.next = nil

        return tailNode
    }

    func remove(at index: Int) -> ListNode? {
        guard index > 0 else {
            return removeHead()
        }

        var node = head

        for _ in 1..<index {
            node = node?.next
        }

        if node == nil { return nil }

        return removeAfter(node!)
    }

    func removeAfter(_ node: ListNode) -> ListNode? {
        defer { node.next = node.next?.next }
        return node.next
    }

    func insert(_ node: ListNode?, after anotherNode: ListNode?) {
        guard let node = node, let anotherNode = anotherNode else { return }
        node.next = anotherNode.next
        anotherNode.next = node
    }
}

extension LinkedList: Sequence {
    struct ListItetator: IteratorProtocol {
        private var current: ListNode?

        init(current: ListNode?) {
            self.current = current
        }

        mutating func next() -> ListNode? {
            defer {
                current = current?.next
            }

            return current
        }
    }

    func makeIterator() -> ListItetator {
        return ListItetator(current: head)
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

let linkedList = LinkedList<Int>()
linkedList.appendHead(0)
linkedList.appendHead(1)
linkedList.removeAfter(linkedList.head!)
linkedList.removeTail()
linkedList.appendHead(2)
linkedList.removeTail()
linkedList.appendTail(3)
linkedList.appendTail(4)
linkedList.appendHead(5)
linkedList.remove(at: 1)
linkedList.appendHead(10)
linkedList.insert(linkedList.removeTail(), after: linkedList.head)
linkedList.removeHead()
linkedList.removeTail()
linkedList.removeTail()

for node in linkedList {
    print(node.value)
}

class DoubleLinkedList<T> {
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
        head?.prev = newNode
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

    func remove(at index: Int) -> ListNode? {
        guard index > 0 else {
            return removeHead()
        }

        var node = head

        for _ in 0..<index {
            node = node?.next
        }

        node?.prev?.next = node?.next
        node?.next?.prev = node?.prev

        return node
    }

    func removeAfter(_ node: ListNode) -> ListNode? {
        defer {
            if tail === node.next {
                tail = node
            }
            
            node.next = node.next?.next
            node.next?.prev = node
        }

        return node.next
    }

    func insert(_ node: ListNode?, after anotherNode: ListNode?) {
        guard let node = node, let anotherNode = anotherNode else { return }
        node.next = anotherNode.next
        node.prev = anotherNode

        anotherNode.next = node
        node.next?.prev = node
    }
}

extension DoubleLinkedList: Sequence {
    struct ListItetator: IteratorProtocol {
        private var current: ListNode?

        init(current: ListNode?) {
            self.current = current
        }

        mutating func next() -> ListNode? {
            defer {
                current = current?.next
            }

            return current
        }
    }

    func makeIterator() -> ListItetator {
        return ListItetator(current: head)
    }
}

extension DoubleLinkedList: CustomStringConvertible {
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

let doubleLinkedList = DoubleLinkedList<Int>()
doubleLinkedList.appendHead(1)
doubleLinkedList.appendHead(2)
doubleLinkedList.removeAfter(doubleLinkedList.head!)
doubleLinkedList.appendHead(3)
doubleLinkedList.appendHead(4)
doubleLinkedList.remove(at: 0)
doubleLinkedList.appendHead(10)
doubleLinkedList.insert(doubleLinkedList.removeTail(), after: doubleLinkedList.head)
doubleLinkedList.removeTail()
doubleLinkedList.appendTail(3)
doubleLinkedList.appendTail(4)
doubleLinkedList.removeHead()
doubleLinkedList.appendHead(5)
doubleLinkedList.removeHead()
doubleLinkedList.removeHead()
doubleLinkedList.removeTail()

for node in doubleLinkedList {
    print(node.value)
}
