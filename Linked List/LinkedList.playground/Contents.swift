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
linkedList.appendHead(1)
linkedList.removeTail()
linkedList.appendHead(2)
linkedList.removeTail()
linkedList.appendTail(3)
linkedList.appendTail(4)
linkedList.appendHead(5)
linkedList.removeHead()
linkedList.removeTail()
linkedList.removeTail()


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
doubleLinkedList.removeTail()
doubleLinkedList.appendTail(3)
doubleLinkedList.appendTail(4)
doubleLinkedList.removeHead()
doubleLinkedList.appendHead(5)
doubleLinkedList.removeHead()
doubleLinkedList.removeHead()
doubleLinkedList.removeTail()

