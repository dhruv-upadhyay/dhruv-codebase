import Foundation

/**
 4.Find the maximum product of any two integers in an array.
 Input: `[1, 20, 30, 4, 5]`
 Output: `600`
 Description: Calculate the highest product that can be obtained from any two numbers in the array.*/

// This function calculates the maximum product of elements from an array up to a specified index.
func maxProduct(nos: [Int], upto: Int) -> Int {
    // Ensure that the specified index is within the bounds of the array.
    guard upto < nos.count else { return 0 }
    
    // Create a copy of the input array to avoid modifying the original array.
    var sortedArray = nos
    
    // Initialize the result variable to store the maximum product.
    var result = 1
    
    // Iterate through the array elements up to the specified index.
    for i in 0..<upto {
        // Compare each element with the elements after it and sort them in descending order.
        for j in (i + 1)..<sortedArray.count {
            if sortedArray[i] < sortedArray[j] {
                let temp = sortedArray[i]
                sortedArray[i] = sortedArray[j]
                sortedArray[j] = temp
            }
        }
        
        // Update the result by multiplying the current element with the previous result.
        result *= sortedArray[i]
    }
    
    // Return the maximum product.
    return result
}

// Example usage:
print(maxProduct(nos: [1, 20, 30, 4, 30], upto: 3)) // Output: 18000

// ------------------------------------------------------------------------

// This function calculates the maximum product of elements from an array up to a specified index using higher-order methods.
func maxProductWithHeigherOrder(nos: [Int], upto: Int = 2) -> Int {
    // Ensure that the specified index is within the bounds of the array.
    guard upto < nos.count else { return 0 }
    
    // Sort the input array in descending order.
    let sortedArray = nos.sorted(by: >)
    
    // Initialize the result variable to store the maximum product.
    var result = 1
    
    // Iterate through the indices up to the specified index and calculate the product of the elements.
    (0..<upto).forEach { index in
        result *= sortedArray[index]
    }
    
    // Return the maximum product.
    return result
}

// Example usage:
print(maxProductWithHeigherOrder(nos: [1, 20, 30, 4, 30], upto: 3)) // Output: 18000
