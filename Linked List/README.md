## Linked List

A linked list is a recursive data structure that is either empty (null) or a reference to a node having a generic item and a reference to a linked list. To implement a linked list, we start with a nested class that defines the node abstraction

## Singly Linked List

Append Head | Remove Head | Append Tail | Remove Tail
:---------: | :---------: | :---------: | :---------: 
O(1)        | O(1)        | O(n)        | O(n) 

```swift
class LinkedList<T> {
    typealias ListNode = Node<T>

    class Node<T> {
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
    
    func reverse() {
        var node = head
        var prev: ListNode? = nil
        while node != nil {
            let next = node?.next
            node?.next = prev
            prev = node
            node = next
        }
        
        head = prev
    }
}
```

Usually it's useful to interate over linked list, this can be done by implementing Sequence and IteratorProtocol protocols

```swift
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
```

## Double Linked List

Contains references to next and previous node. In trade of extra memory gain constant time for tail appending and removing.

Append Head | Remove Head | Append Tail | Remove Tail
:---------: | :---------: | :---------: | :---------: 
O(1)        | O(1)        | O(1)        | O(1) 

```swift
class DoubleLinkedList<T> {
    typealias ListNode = Node<T>

    class Node<T> {
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
```

## Circular Linked List

Double linked list where last node points to first node and first node to last.
