## Insertion Sort

The algorithm that people often use to sort bridge hands is to consider the cards one at a time, inserting each into its proper place among those already considered (keeping them sorted). In a computer implementation, we need to make space to insert the current item by moving larger items one position to the right, before inserting the current item into the vacated position.

Complexity: **O(n^2)**  
Space: **O(1)**  
Stable: **Yes**  
In-Place: **Yes** 

```swift
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
```