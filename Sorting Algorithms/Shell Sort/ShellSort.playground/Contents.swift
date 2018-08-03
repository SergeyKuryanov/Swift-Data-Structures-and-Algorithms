extension Array where Element: Comparable {
    mutating func shellSort() {
        var h = 1;
        while (h < self.count / 3) {
            h = 3 * h + 1;
        }

        while (h >= 1) {
            for i in h..<self.count {
                let temp = self[i]

                var j = i

                while j > h - 1 && temp < self[j - h] {
                    self[j] = self[j - h]

                    j -= h
                }

                self[j] = temp
            }

            h /= 3
        }
    }
}

var array = [10, 9, 6, 4, 2, 1]
array.shellSort()
