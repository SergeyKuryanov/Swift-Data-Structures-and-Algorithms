## Two Sum

From array of digits we need to return two number which sum produce some target number. Solution is pretty straigforward - we use dictionary to save already seen numbers and check if needed number exists.

Time | Memory |
:--: | :------: 
O(n) | O(n) 

```swift
func twoSum(_ nums: [Int], target: Int) -> [Int] {
    guard nums.count >= 2 else { return [] }

    var cache = [Int : Int]()

    for index in 0..<nums.count {
        let value = nums[index]
        let difference = target - value

        if let secondIndex = cache[difference] {
            return [index, secondIndex]
        } else {
            cache[value] = index
        }
    }

    return []
}
```

There is also another solution which need sorting and not so efficinent, but will help with another problems.

Idea in maintaning two indices for sorted array. We starting from one index pointing to first element and second index pointing to last.
```
-5 -4 -3 -2 -1 0 1 2 3 4 5
 f                       s
```

If sum is less that we need we increase first index
```
-5 -4 -3 -2 -1 0 1 2 3 4 5
-> f                     s
```

If sum is more that we need - we decrease second index
```
-5 -4 -3 -2 -1 0 1 2 3 4 5
 f                     s <-
```

If value equal to target we do both - increase first and decrease second indices. To avoid duplicates we update indices until get different value.

Time | Memory |
:--: | :------: 
O(n log n) | O(n) 

```swift
func twoSum(_ nums: [Int], _ target: Int) -> [[Int]] {
    guard nums.count >= 2 else { return [] }

    var nums = nums.sorted()

    var result = [[Int]]()

    var firstIndex = 0
    var secondIndex = nums.count - 1

    while firstIndex < secondIndex {
        let sum = nums[firstIndex] + nums[secondIndex]

        if sum < target {
            firstIndex += 1
        } else if sum > target {
            secondIndex -= 1
        } else {
            result.append([nums[firstIndex], nums[secondIndex]])

            repeat { firstIndex += 1 }
                while firstIndex < secondIndex && nums[firstIndex] == nums[firstIndex - 1]

            repeat { secondIndex -= 1 }
                while secondIndex > firstIndex && nums[secondIndex] == nums[secondIndex + 1]
        }
    }

    return result
}
```

## Tree Sum

For tree sum we need to reduce problem to two sum. To do this we need to iterate over array and search two sum for current value. To avoid duplicates we stip values equal to previos.

Time | Memory |
:--: | :------: 
O(n^2) | O(n) 

```swift
func threeSum(_ nums: [Int], _ target: Int) -> [[Int]] {
    guard nums.count >= 3 else { return [] }

    var nums = nums.sorted()

    var result = [[Int]]()

    for firstIndex in 0..<nums.count - 2 {
        if firstIndex > 0 && nums[firstIndex] == nums[firstIndex - 1] { continue }

        var secondIndex = firstIndex + 1
        var thirdIndex = nums.count - 1

        while secondIndex < thirdIndex {
            let sum = nums[firstIndex] + nums[secondIndex] + nums[thirdIndex]

            if sum < target {
                secondIndex += 1
            } else if sum > target {
                thirdIndex -= 1
            } else {
                result.append([nums[firstIndex], nums[secondIndex], nums[thirdIndex]])

                repeat { secondIndex += 1 }
                    while secondIndex < thirdIndex && nums[secondIndex] == nums[secondIndex - 1]

                repeat { thirdIndex -= 1 }
                    while thirdIndex > secondIndex && nums[thirdIndex] == nums[thirdIndex + 1]
            }
        }
    }

    return result
}
```

## Four Sum

Four sum probles can be reduced to tree sum and than to two sum in same way.

Time | Memory |
:--: | :------: 
O(n^3) | O(n) 

```swift
func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
    guard nums.count >= 4 else { return [] }

    var nums = nums.sorted()

    var result = [[Int]]()

    for firstIndex in 0..<nums.count - 3 {
        if firstIndex > 0 && nums[firstIndex] == nums[firstIndex - 1] { continue }

        for secondIndex in firstIndex + 1..<nums.count - 2 {
            if secondIndex > firstIndex + 1 && nums[secondIndex] == nums[secondIndex - 1] { continue }

            var thirdIndex = secondIndex + 1
            var fourIndex = nums.count - 1

            while thirdIndex < fourIndex {
                let sum = nums[firstIndex] + nums[secondIndex] + nums[thirdIndex] + nums[fourIndex]

                if sum < target {
                    thirdIndex += 1
                } else if sum > target {
                    fourIndex -= 1
                } else {
                    result.append([nums[firstIndex], nums[secondIndex], nums[thirdIndex], nums[fourIndex]])

                    repeat { thirdIndex += 1 }
                        while thirdIndex < fourIndex && nums[thirdIndex] == nums[thirdIndex - 1]

                    repeat { fourIndex -= 1 }
                        while fourIndex > thirdIndex && nums[fourIndex] == nums[fourIndex + 1]
                }
            }
        }
    }

    return result
}
```
Alternative solution will be to trade some memory to reduce time complexity for most cases. First we build cache for sum pairs. And than iterate and finding another pairs. Many optimizatoins can be applied here.

Time | Memory |
:--: | :------: 
O(n^3) | O(n) 

```swift
func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
    guard nums.count >= 4 else { return [] }

    var result = [[Int]]()
    var nums = nums.sorted()

    var cache = [Int: [[Int]]]()
    var results = Set<String>()

    for firstIndex in 0..<nums.count - 3 {
        if firstIndex > 0 && nums[firstIndex] == nums[firstIndex - 1] { continue }

        for secondIndex in firstIndex + 1..<nums.count - 2 {
            if secondIndex > firstIndex + 1 && nums[secondIndex] == nums[secondIndex - 1] { continue }

            let sum = nums[firstIndex] + nums[secondIndex]
            var indices = cache[sum, default: [[Int]]()]
            indices.append([firstIndex, secondIndex])
            cache[sum] = indices
        }
    }

    for thirdIndex in 2..<nums.count - 1 {
        for fourIndex in thirdIndex + 1..<nums.count {

            let sum = nums[thirdIndex] + nums[fourIndex]

            if let sums = cache[target - sum] {
                for indices in sums {
                    let firstIndex = indices.first!
                    let secondIndex = indices.last!
                    guard thirdIndex > secondIndex else { continue }

                    let numbers = [nums[firstIndex], nums[secondIndex], nums[thirdIndex], nums[fourIndex]]
                    let key = "\(numbers)"

                    if results.contains(key) { continue }

                    result.append(numbers)
                    results.insert(key)
                }
            }
        }
    }

    return result
}
```