extension Array where Element: Comparable {
    mutating func heapSort() {
        for i in stride(from: count / 2, through: 0, by: -1) {
            sink(i, to: count)
        }

        for i in stride(from: count - 1, to: 0, by: -1) {
            swapAt(0, i)
            sink(0, to: i)
        }
    }

    private mutating func sink(_ from: Int, to: Int) {
        var index = from

        while child(of: index) < to {
            var childIndex = child(of: index)
            let secondChildIndex = childIndex + 1

            if secondChildIndex < to && self[childIndex] < self[secondChildIndex] {
                childIndex = secondChildIndex
            }

            if self[childIndex] < self[index] { break }

            swapAt(childIndex, index)

            index = childIndex
        }
    }

    private func child(of index: Int) -> Int {
        return index * 2 + 1
    }
}

var array = (0...100).shuffled()
array.heapSort()
