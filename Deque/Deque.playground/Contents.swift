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

struct LinkedListDeque<T> {
    private let linkedList = LinkedList<T>()

    private(set) var size = 0

    mutating func popLeft() -> T? {
        guard size > 0 else { return nil }
        size -= 1
        return linkedList.removeHead()?.value
    }

    mutating func popRight() -> T? {
        guard size > 0 else { return nil }
        size -= 1
        return linkedList.removeTail()?.value
    }

    mutating func pushLeft(_ value: T) {
        size += 1
        linkedList.appendHead(value)
    }

    mutating func pushRight(_ value: T) {
        size += 1
        linkedList.appendTail(value)
    }
}

extension LinkedListDeque: CustomStringConvertible {
    public var description: String {
        return linkedList.description
    }
}

var linkedListDeque = LinkedListDeque<Int>()
linkedListDeque.pushRight(1)
linkedListDeque.pushLeft(2)
linkedListDeque.pushRight(3)
linkedListDeque.pushLeft(4)
linkedListDeque.popLeft()
linkedListDeque.popRight()
linkedListDeque

struct ResizableArrayDeque<T> {
    private var array = Array<T?>(repeating: nil, count: 1)
    private var headIndex = 0
    private var tailIndex = 0
    var size: Int {
        return tailIndex - headIndex + 1
    }

    mutating func popLeft() -> T? {
        guard size > 0 else { return nil }

        defer {
            array[headIndex] = nil
            headIndex += 1
            resizeIfNeed()
        }

        return array[headIndex]
    }

    mutating func popRight() -> T? {
        guard size > 0 else { return nil }

        defer {
            array[tailIndex] = nil
            tailIndex -= 1
            resizeIfNeed()
        }

        return array[tailIndex]
    }

    mutating func pushLeft(_ value: T) {
        headIndex -= 1
        resizeIfNeed()
        array[headIndex] = value
    }

    mutating func pushRight(_ value: T) {
        tailIndex += 1
        resizeIfNeed()
        array[tailIndex] = value
    }

    mutating private func resizeIfNeed() {
        if headIndex < 0 || tailIndex >= array.count {
            resizeTo(size: size * 2)
        } else if size <= array.count / 4 {
            resizeTo(size: array.count / 2)
        }
    }

    mutating private func resizeTo(size newSize: Int) {
        var newArray = Array<T?>(repeating: nil, count: newSize)

        let newHead = (newSize - size) / 2
        let newTail = newHead + size - 1

        newArray[newHead...newTail] = array[max(headIndex, 0)...min(tailIndex, array.count - 1)]
        headIndex = newHead
        tailIndex = newTail
        array = newArray
    }
}

extension ResizableArrayDeque: CustomStringConvertible {
    public var description: String {
        return "size: \(size), \(array.compactMap { $0 })"
    }
}

var resizableArrayDeque = ResizableArrayDeque<Int>()
resizableArrayDeque.pushRight(1)
resizableArrayDeque.pushLeft(2)
resizableArrayDeque.pushRight(3)
resizableArrayDeque.pushLeft(4)
resizableArrayDeque.popLeft()
resizableArrayDeque.popRight()
resizableArrayDeque

