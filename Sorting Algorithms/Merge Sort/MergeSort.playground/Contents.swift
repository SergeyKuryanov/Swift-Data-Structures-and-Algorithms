extension Array where Element: Comparable {
    mutating func mergeSort() {
        mergeSort(lo: 0, hi: count - 1)
    }

    private mutating func mergeSort(lo: Int, hi: Int) {
        guard lo < hi else { return }

        let mid = lo + (hi - lo) / 2

        mergeSort(lo: lo, hi: mid)
        mergeSort(lo: mid + 1, hi: hi)

        return merge(lo: lo, hi: hi)
    }

    private mutating func merge(lo: Int, hi: Int) {
        let aux = self[lo...hi]

        let mid = lo + (hi - lo) / 2
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
        var subArraySize = 2
        while subArraySize < count { defer { subArraySize *= 2 }
            for lo in stride(from: 0, to: count - subArraySize, by: subArraySize) {
                merge(lo: lo, hi: Swift.min(lo + subArraySize - 1, count - 1))
            }
        }
    }
}

var array = [10, 9, 6, 4, 2, 1, 13, 15, 10, 21, 103, 1982]
var array2 = array

array.mergeSort()
array2.mergeSortBottomUp()
