import Foundation

/**

#You are keeping the scores for a baseball game with strange rules. At the beginning of the game, you start with an empty record.

#You are given a list of strings operations, where operations[i] is the ith operation you must apply to the record and is one of the following:

* An integer x. Record a new score of x.
* '+'. Record a new score that is the sum of the previous two scores.
* 'D'. Record a new score that is the double of the previous score.
* 'C'. Invalidate the previous score, removing it from the record.
* Return the sum of all the scores on the record after applying all the operations.

#The test cases are generated such that the answer and all intermediate calculations fit in a 32-bit integer and that all operations are valid.

 
#Example 1:

* Input: ops = ["5","2","C","D","+"]
* Output: 30

#Explanation:
* "5" - Add 5 to the record, record is now [5].
* "2" - Add 2 to the record, record is now [5, 2].
* "C" - Invalidate and remove the previous score, record is now [5].
* "D" - Add 2 * 5 = 10 to the record, record is now [5, 10].
* "+" - Add 5 + 10 = 15 to the record, record is now [5, 10, 15].
* The total sum is 5 + 10 + 15 = 30.

#Example 2:

* Input: ops = ["5","-2","4","C","D","9","+","+"]
* Output: 27

#Explanation:
* "5" - Add 5 to the record, record is now [5].
* "-2" - Add -2 to the record, record is now [5, -2].
* "4" - Add 4 to the record, record is now [5, -2, 4].
* "C" - Invalidate and remove the previous score, record is now [5, -2].
* "D" - Add 2 * -2 = -4 to the record, record is now [5, -2, -4].
* "9" - Add 9 to the record, record is now [5, -2, -4, 9].
* "+" - Add -4 + 9 = 5 to the record, record is now [5, -2, -4, 9, 5].
* "+" - Add 9 + 5 = 14 to the record, record is now [5, -2, -4, 9, 5, 14].
* The total sum is 5 + -2 + -4 + 9 + 5 + 14 = 27.

#Example 3:

 *  Input: ops = ["1","C"]
 * Output: 0

#Explanation:
- "1" - Add 1 to the record, record is now [1].
- "C" - Invalidate and remove the previous score, record is now [].
- Since the record is empty, the total sum is 0.
 
#Constraints:

- 1 <= operations.length <= 1000
- operations[i] is "C", "D", "+", or a string representing an integer in the range [-3 * 104, 3 * 104].
- For operation "+", there will always be at least two previous scores on the record.
- For operations "C" and "D", there will always be at least one previous score on the record.

*/

func calPoints(_ ops: [String]) -> Int {
    // Initialize an array to keep track of the scores
    var record = [Int]()
    
    // Iterate over each operation in the ops array
    ops.forEach { op in
        switch op {
        case "+":
            // If the operation is '+', sum the last two scores and append the result to the record
            // suffix(2) gets the last two elements of the array
            let lastTwoScores = record.suffix(2)
            // Check if there are at least two scores to sum
            if lastTwoScores.count == 2 {
                // Sum the last two scores and append to the record
                record.append(lastTwoScores.reduce(0, +))
            }
        case "D":
            // If the operation is 'D', double the last score and append it to the record
            if let lastScore = record.last {
                // Double the last score and append to the record
                record.append(lastScore * 2)
            }
        case "C":
            // If the operation is 'C', remove the last score from the record
            if !record.isEmpty {
                // Remove the last score from the record
                record.removeLast()
            }
        default:
            // If the operation is a number, convert it to an integer and append it to the record
            if let score = Int(op) {
                // Append the integer score to the record
                record.append(score)
            }
        }
    }
    
    // Calculate and return the sum of all the scores in the record
    return record.reduce(0, +)
}

// Example usage
let ops1 = ["5","2","C","D","+"]
print(calPoints(ops1)) // Output: 30

let ops2 = ["5","-2","4","C","D","9","+","+"]
print(calPoints(ops2)) // Output: 27

let ops3 = ["1","C"]
print(calPoints(ops3)) // Output: 0

