import Foundation

/**
 1. Write a function to reverse the elements of an array in place.
   Input: `[1, 2, 3, 4, 5]`
   Output: `[5, 4, 3, 2, 1]`
   Description: Reverse the order of elements in the array without using any additional space.
 */

// This function reverses the elements of an input array of integers in place.
// It uses an inout parameter to modify the original array directly.
func reverseNumbers(nos: inout [Int]) {
    // Get the count of elements in the array.
    let count = nos.count
    
    // If the array has 1 or no elements, there's nothing to reverse, so return early.
    guard count > 1 else {
        return
    }
    
    // Iterate from the start of the array to the middle.
    for i in 0..<(count / 2) {
        // Swap the element at index `i` with the element at the mirrored index from the end.
        let temp = nos[i]                  // Store the current element in a temporary variable.
        nos[i] = nos[count - i - 1]        // Assign the element from the mirrored index to the current index.
        nos[count - i - 1] = temp          // Assign the temporary variable to the mirrored index.
    }
}

// Example usage:
var arr = [1, 2, 3, 4, 5]                // Initialize an array of integers.
print("Input: \(arr)")                   // Print the original array.
reverseNumbers(nos: &arr)                // Call the function to reverse the array in place.
print("Output: \(arr)")                  // Print the reversed array.

// -----------------------------------------------------------------------------

// Using higher-order methods
// Declare and initialize an array of integers.
var array = [1, 2, 3, 4, 5]

// Print the original array to the console.
print("Input: \(array)")

// Use the `reversed()` higher-order method to reverse the array.
// The `reversed()` method returns a new array with the elements in reverse order.
array = Array(array.reversed())

// Print the reversed array to the console.
print("Output: \(array)")

