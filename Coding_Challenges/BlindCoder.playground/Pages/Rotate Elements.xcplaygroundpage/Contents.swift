import Foundation

/**
 3. Rotate an array to the right by `k` steps.
   Input: `([1, 2, 3, 4, 5], 2)`
   Output: `[4, 5, 1, 2, 3]`
   Description: Move each element of the array to the right by `k` positions, wrapping elements around.*/

enum Direction: Int {
    case left = 0
    case right
}

// This function rotates the elements of an array in the specified direction by a certain number of steps.
// It modifies the original array in place.
func rotateArray(nos: inout [Int], steps: Int = 2, direction: Direction = .right) {
    // Ensure that the array has more than one element and the number of steps is within bounds.
    guard nos.count > 1 else { return }
    guard steps <= nos.count else { return }

    // Iterate through the steps and perform rotation accordingly.
    for _ in 0..<steps {
        switch direction {
            case .left:
                // For left rotation, remove the first element and append it to the end.
                let temp = nos.removeFirst()
                nos.append(temp)
            case .right:
                // For right rotation, remove the last element and insert it at the beginning.
                let temp = nos.removeLast()
                nos.insert(temp, at: 0)
        }
    }
}

// Example usage:
var array = [1, 2, 3, 4, 5]
rotateArray(nos: &array, direction: .left)
print(array)

//--------------------------------------------------------------

// This function shifts the elements of an array to the right by a specified number of positions.
func shiftRight<T>(_ array: [T], by positions: Int) -> [T] {
    // Get the count of elements in the array.
    let count = array.count
    
    // Calculate the effective shift (handling cases where positions may be greater than the count).
    let effectiveShift = positions % count
    // If the effective shift is zero, return the original array as there's no change.
    guard effectiveShift > 0 else { return array }
    
    // Split the array into two parts: the suffix part to be shifted to the front and the prefix part to remain at the end.
    let suffixPart = array.suffix(effectiveShift)
    let prefixPart = array.prefix(count - effectiveShift)
    
    // Concatenate the suffix and prefix parts to form the shifted array.
    return Array(suffixPart + prefixPart)
}

// Example Usage
let array2 = [1, 2, 3, 4, 5, 6, 8, 9]
let shiftedArray = shiftRight(array2, by: 5)
print(shiftedArray) // Output: [4, 5, 1, 2, 3]

