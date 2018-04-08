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

struct Steque<T> {
    private let linkedList = LinkedList<T>()

    mutating func pop() -> T? {
        return linkedList.removeHead()?.value
    }

    mutating func push(_ value: T) {
        linkedList.appendHead(value)
    }

    mutating func enqueue(_ value: T) {
        linkedList.appendTail(value)
    }
}

extension Steque: CustomStringConvertible {
    public var description: String {
        return linkedList.description
    }
}

var steque = Steque<Int>()
steque.push(1)
steque.push(2)
steque.enqueue(3)
steque.pop()
steque.enqueue(4)
steque.pop()
