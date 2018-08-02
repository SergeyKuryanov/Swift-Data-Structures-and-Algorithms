## Selection Sort

This is one of the simplest sorting algorithms. It works as follows: First, find the smallest item in the array and exchange it with the first entry (itself if the first entry is already the smallest). Then, find the next smallest item and exchange it with the sec- ond entry. Continue in this way until the entire array is sorted. This method is called _selection sort_ because it works by repeatedly selecting the smallest remaining item.

Complexity: **O(n^2)**

```swift
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
```