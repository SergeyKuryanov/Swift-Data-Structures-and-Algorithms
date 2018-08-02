extension Array where Element: Comparable {
    mutating func insertionSort() {
        for i in 1..<self.count {
            let temp = self[i]

            var j = i

            while j > 0 && temp < self[j - 1] {
                self[j] = self[j - 1]

                j -= 1
            }

            self[j] = temp
        }
    }
}

var array = [10, 9, 6, 4, 2, 1]
array.insertionSort()
