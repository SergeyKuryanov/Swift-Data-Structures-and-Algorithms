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
        newNode.prev = tail
        head = newNode
    }

    func appendTail(_ value: T) {
        let newNode = ListNode(value)
        if let tail = tail {
            tail.next = newNode
            head?.prev = tail
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
linkedList.appendHead(2)
linkedList.appendTail(3)
linkedList.appendTail(4)
linkedList.appendHead(5)
linkedList.removeHead()
linkedList.removeTail()
