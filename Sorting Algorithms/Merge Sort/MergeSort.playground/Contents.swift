extension Array where Element: Comparable {
    mutating func mergeSort() {
        mergeSort(lo: 0, hi: count - 1)
    }

    private mutating func mergeSort(lo: Int, hi: Int) {
        guard lo < hi else { return }

        let mid = lo + (hi - lo) / 2

        mergeSort(lo: lo, hi: mid)
        mergeSort(lo: mid + 1, hi: hi)

        return merge(lo: lo, mid: mid, hi: hi)
    }

    private mutating func merge(lo: Int, mid: Int, hi: Int) {
        let aux = self[lo...hi]

        var leftIndex = lo
        var rightIndex = mid + 1

        for i in lo...hi {
            if leftIndex > mid {
                self[i] = aux[rightIndex]
                rightIndex += 1
            } else if rightIndex > hi {
                self[i] = aux[leftIndex]
                leftIndex += 1
            } else if aux[leftIndex] < aux[rightIndex] {
                self[i] = aux[leftIndex]
                leftIndex += 1
            } else {
                self[i] = aux[rightIndex]
                rightIndex += 1
            }
        }
    }

    mutating func mergeSortBottomUp() {
        var subArraySize = 1
        while subArraySize < count { defer { subArraySize *= 2 }
            for lo in stride(from: 0, to: count - subArraySize, by: subArraySize * 2) {
                merge(lo: lo, mid: lo + subArraySize - 1, hi: Swift.min(lo + subArraySize * 2, count) - 1)
            }
        }
    }
}

var array = (0...100).shuffled()
var array2 = array.shuffled()

array.mergeSort()
array2.mergeSortBottomUp()
