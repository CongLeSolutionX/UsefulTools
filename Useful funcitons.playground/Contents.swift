
import UIKit
//MARK: - is vs isKind(of:) vs isMember(of:)
/// `is` operator is used to check the type
/// of a class instance, subclass instace, or a struct instance.

class A { }

let a = A()

if a is A {
  print("a is A") // a is A
}
//-------------------------
class SubA: A { }

let subA = SubA()

if subA is SubA {
  print("subA is SubA") // subA is SubA
}

if subA is A {
  print("subA is A") // subA is A
}
//-------------------------
struct B { }

let b = B()

if b is B {
  print("b is B") // b is B
}

//-------------------------
/// `isKind(of:)` works with `class` and adopts the `NSObjectProtocol`
/// This function is used to check the given value is an instance of a class
///  or an instance of any classes that inherits from that class.
/// This function is not available to `struct`
class MyClass: NSObject { }

let myClass = MyClass()

if myClass.isKind(of: MyClass.self){
  print("myClass is kind of MyClass") // myClass is kind of MyClass
}

if myClass.isKind(of: NSObject.self) {
  print("myClass is kind of NSObject") // myClass is kind of NSObject
}
//-------------------------
/// `isMember(of:)` works with class only and adopts the `NSObjectProtocol`
if myClass.isMember(of: MyClass.self) {
  print("myClass is member of MyClass") // myClass is member of MyClass
}

if myClass.isMember(of: NSObject.self) {
  print("myClass is member of MyClass") // myClass is NOT a memebr of NSObject
}


//MARK: - append() vs appending()
/// These function using in concatenating 2 String variables.

/// `append()` is the mutating method that appends the given string to this string, which
/// is similar to `addition assignment operator` `+=`

var hello: String = "Hello" // var allows mutating
hello.append(" World")
print(hello) // Hello World

var hi: String = "Hi" // var allows mutating
hi += " Swift"
print(hi) // Hi Swift
//-------------------------
/// `appending()` is inherited from `NSString` type.
/// It creates a new`String` value the same way the `addition opertor` `+` does.

let greeting: String = "Good" // let stores constant
let result = greeting.appending(" morning")
print(result) // Good morning

let result2 = greeting + " afternoon"
print(result2) // Good afternoon

// MARK: -  sort() vs sorted()
/// These function are built-in methods of Swift `array` that sort the array of `Element` in ascending order by deffault.
/// They are available when the arry `Element` conforms to the `Comparable` protocol.
/// The complexity is O(n log n) for both, where n is the length of the collection.

///`sort()` mutates the existing array ans sorts the elements in ascending order by default.
/// use `sort(by: >)` to sort the elements in descending order.
var httpStatusCodes = ["200", "404", "400", "300"]
httpStatusCodes.sort()
print(httpStatusCodes) // ["200", "300", "400", "404"]

httpStatusCodes.sort(by: >)
print(httpStatusCodes) // ["404", "400", "300", "200"]

//-------------------------
/// `sorted()` returns the elements of the sequence in ascending oprder by default.
/// use `sort(by: >)` to sort the elements in descending order.
let httpStatusCodesAgain = ["200", "404", "400", "300"]
var sorted = httpStatusCodesAgain.sorted()
print(sorted) // ["200", "300", "400", "404"]

let sortGreater = httpStatusCodesAgain.sorted(by: >)
print(sortGreater) // ["404", "400", "300", "200"]

//MARK: - reverse() vs reversed()
/// These methods work with collection of `Element` where the
/// `Element` adopts the `Comparable` protocol.
/// The coleciton can be an `Array`, `String`, etc

/// `reverse()` is the mutating method that reverses the elements of the collection in place.
/// The complexity is O(n), where n is the number of elements in the collection.
sorted.reverse()
print(sorted) // ["404", "400", "300", "200"]

//-------------------------
/// `revered()` wraps the underlying collection with the `ReversedCollection` instance, which
/// provides access to its element in reverse order. It doesn't allocate any new space for the collection.
/// The complexity is O(1).

let reveredCodes = sorted.reversed()
print(reveredCodes) // ReversedCollection<Array<String>>(_base: ["404", "400", "300", "200"])

// MARK: - shuffle() vs shuffled()
/// These methods shuffle the collection of `Element` instance starting in Swift 4.2.
/// They randomply reorder the elements but dont need the elements to adopt the `Comparable` protocol.
/// The complexity is O(n), where n is the length of the collection.

/// `shuffle()`mutates the existing collection.
/// It can be used with an array of comparable and non-comparable elements.

// non-comparable elements
struct C {
  let flag: String
}

var temp = [C(flag: "1"), C(flag: "3"), C(flag: "2"), C(flag: "4")]
print(temp) // [__lldb_expr_36.C(flag: "1"), __lldb_expr_36.C(flag: "3"), __lldb_expr_36.C(flag: "2"), __lldb_expr_36.C(flag: "4")]

temp.shuffle()
print(temp) // [__lldb_expr_36.C(flag: "1"), __lldb_expr_36.C(flag: "4"), __lldb_expr_36.C(flag: "3"), __lldb_expr_36.C(flag: "2")]

// comparable elements

httpStatusCodes.shuffle() // has original value as ["200", "404", "400", "300"]
print(httpStatusCodes)  // ["400", "200", "404", "300"]

//-------------------------
/// `shuffled()` returns the shuffled elements of the sequence, which can be a `String`, `Array`, etc.

// non-comparable elements
let shuffled = temp.shuffled()
print(shuffled) // [__lldb_expr_40.C(flag: "4"), __lldb_expr_40.C(flag: "2"), __lldb_expr_40.C(flag: "1"), __lldb_expr_40.C(flag: "3")]

// comparable element
let helloWorld = "Hello World"
let shuffledChars = helloWorld.shuffled()
print(shuffledChars) // ["l", "H", " ", "d", "W", "l", "o", "r", "l", "o", "e"]


// MARK: - isEmpty() vs. count == 0
///  Both methods check if a string is empty. we prefer using `isEmpty()`

/// `isEmpty()` compares the start index with the end index of the string.
/// The complexity is O(1).
let stringless = ""
extension String {
  subscript(i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }
}
stringless.isEmpty // return boolean result faster

/// `.count == 0` loops the string to count all characters.
/// The complexity is O(n).
stringless.count == 0 // return boolean result slower
