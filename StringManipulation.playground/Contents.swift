import UIKit

// MARK: - String Basics
// There are 2 ways to create a string in Swift: String Literal and string class instance
// 1. String literal
var textString = "This is an example string!"
print(textString)

// 2. String class instance
var stringInstance = String("This is a string created by a String class")
print(stringInstance)

// MARK: -  String Iteration
for char in "Swift" {
  print(char)
}
print("==============")
// or
"ObjectiveC".forEach { char in
  print(char)
}
print("==============")
// or
"Again".forEach { print($0) }

print("==============")


// MARK: - String Concattenation

let firstString = "Hello,"
let secondString = " world!"
var finalString = firstString + secondString
print(finalString)


// MARK: - Substring with function
var originalString = "My name is Cong Le"
/// Find the index of letter 'C' via using index function.
/// We use the function `startIndex` to  get the first index of the `initialString`, starting with value as 1.
/// and set the vallue for `offsetBy` by the number of chars before letter 'C', in this case is 11
var index = originalString.index(originalString.startIndex, offsetBy: 11)
originalString.removeSubrange(originalString.startIndex..<index)
print(originalString)
