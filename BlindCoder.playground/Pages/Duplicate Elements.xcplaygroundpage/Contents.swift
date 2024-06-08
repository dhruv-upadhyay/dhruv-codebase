import UIKit

/**
 2. Identify any duplicate elements in an array.
   Input: `[1, 2, 3, 4, 4, 5, 2]`
   Output: `[2, 4]`
   Description: Find all elements that appear more than once in the array.*/

// Using for loops
func findDuplicatesNos(nos: [Int]) -> [Int] {
    // Initialize an empty array to store the duplicate integers.
    var result = [Int]()
    
    // Iterate through the array with index `i` and element `no`.
    for (i, no) in nos.enumerated() {
        // Iterate through the array starting from the element right after `i`.
        for j in (i + 1)..<nos.count {
            // Check if the current element `no` is equal to the element at index `j`.
            // Also, ensure the element `no` is not already in the `result` array.
            if no == nos[j] && !result.contains(no) {
                // If a duplicate is found and it's not already in the result, add it to the result.
                result.append(no)
            }
        }
    }
    
    // Return the array containing all unique duplicates found in the input array.
    return result
}

print("Result using loops: \(findDuplicatesNos(nos: [1, 2, 3, 4, 4, 5, 2]))")
// Output: [2, 4]

// -----------------------------------------------------------------------------

/** Using higher-order method
 * This function finds and returns the duplicate elements in an array.
 * It works for any type that conforms to the Hashable protocol.*/
func findDuplicates<T: Hashable>(in array: [T]) -> [T] {
    // Step 1: Use `reduce` to create a dictionary that counts occurrences of each element in the array.
    // `reduce(into:)` initializes an empty dictionary and populates it with the count of each element.
    let occurrences = array.reduce(into: [:]) { counts, element in
        // For each element in the array, increase its count in the dictionary.
        counts[element, default: 0] += 1
    }
    
    // Step 2: Filter the dictionary to include only elements that appear more than once.
    // `filter` retains only the key-value pairs where the value (count) is greater than 1.
    // `map` transforms the filtered key-value pairs into an array of keys (the duplicate elements).
    let duplicates = occurrences.filter { $0.value > 1 }.map { $0.key }
    
    // Return the array of duplicate elements.
    return duplicates
}

print("Result with higher-order methods: \(findDuplicates(in: [1, 2, 3, 4, 5, 1, 2, 6, 7, 8, 8, 9, 9]))") // Output: [1, 2, 8, 9]
