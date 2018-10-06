## Shell Sort

To exhibit the value of knowing properties of elementary sorts, we next consider a fast algorithm based on insertion sort. Insertion sort is slow for large unordered arrays because the only exchanges it does involve adjacent entries, so items can move through the array only one place at a time. For example, if the item with the smallest key happens to be at the end of the array, N􏰀1 exchanges are needed to get that one item where it belongs. _Shellsort_ is a simple extension of insertion sort that gains speed by allowing exchanges of array entries that are far apart, to produce partially sorted arrays that can be efficiently sorted, eventually by insertion sort.

Complexity: **Better than O(n^2), depends on H choosing strategy**  
Space: **O(1)**  
Stable: **No**  
In-Place: **Yes** 

```swift
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
```