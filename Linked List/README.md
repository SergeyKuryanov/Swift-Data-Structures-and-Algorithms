## Linked List

A linked list is a recursive data structure that is either empty (null) or a reference to a node having a generic item and a reference to a linked list. To implement a linked list, we start with a nested class that defines the node abstraction

Append Head | Remove Head | Append Tail | Remove Tail
:---------: | :---------: | :---------: | :---------: 
O(1)        | O(1)        | O(n)        | O(n) 


## Singly Linked List

```swift
class LinkedList<T> {
    typealias ListNode = Node<T>

    class Node<T> {
        var next: Node<T>?
        let value: T

        init(_ value: T) {
            self.value = value
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

        while let next = node.next, next.next != nil {
            node = next
        }

        let tailNode = node.next
        node.next = nil

        return tailNode
    }
}
```

## Double Linked List

Contains references to next and previous node

```swift
class Node<T> {
    var next: Node<T>?
    var prev: Node<T>?
    let value: T

    init(_ value: T) {
        self.value = value
    }
}
```

## Circular Linked List

Double linked list where last node points to first node and first node to last.

```swift
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
```