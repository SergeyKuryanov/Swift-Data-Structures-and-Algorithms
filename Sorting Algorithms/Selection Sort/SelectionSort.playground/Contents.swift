extension Array where Element: Comparable {
    mutating func selectionSort() {
        for i in 0..<self.count {
            var min = i

            for j in i + 1..<self.count {
                if self[min] > self[j] {
                    min = j
                }
            }

            swapAt(i, min)
        }
    }
}

var array = [10, 9, 6, 4, 2, 1]
array.selectionSort()
