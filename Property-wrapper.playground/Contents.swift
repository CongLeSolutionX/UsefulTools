
import Foundation

// MARK: Property wrapper use cases:
// MARK: - 1. Property validation

@propertyWrapper
struct CVV {
  var wrappedValue: String {
    get {
      return value
    }
    set {
      guard newValue.count >= 3 else { return }
    }
  }
  
  private var defaultValue: String
  private var value:  String
  
  init(defaultValue: String) {
    self.defaultValue = defaultValue
    self.value = defaultValue
  }
}

// we now can use `CVV` to wrap the property
struct BankCard {
  @CVV(defaultValue: "000")  var cvv: String
  
  init(cvv: String) {
    self.cvv = cvv
  }
  
}

let card1 = BankCard(cvv: "12")
let card2 = BankCard(cvv: "1234")
print(card1.cvv) // prints the default value "000"
print(card2.cvv) // prints the vale "123456"


// MARK: - 2. Decoding a JSON structure
//protocol Convertible {
//  associatedtype FromType: Decodable
//  init?(_ value: FromType)
//}
//
//@propertyWrapper
//struct Converted<WrappedType: Decodable & Convertible>: Decodable {
//  var wrappedValue: WrappedType
//  typealias  ConvertedFromType = WrappedType.FromType
//
//  init(wrappedValue: WrappedType) {
//    self.wrappedValue = wrappedValue
//  }
//
//  init(from decoder: Decoder) throws {
//    let container = try decoder.singleValueContainer()
//    if let value = try? container.decode(WrappedType.self) {
//      self.wrappedValue = value
//    } else {
//      let valueString = try container.decode(ConvertedFromType.self)
//      guard let value = WrappedType(valueString) else {
//        throw DecodingError.dataCorruptedError(in: container,
//                                               debugDescription: "Data is not \(WrappedType.self) nor \(ConvertedFromType.self)")
//      }
//      self.wrappedValue = value
//    }
//  }
//
//}
//
//extension Int: Convertible {
//  typealias FromType = String
//}
//// using `Converted` struct
//struct Sample: Decodable{
//  @Converted var sampleInt: Int
//}
//
//let json = """
//{
//  "sampleInt:" "123"
//}
//""".data(using: .utf8)!
//
//let decoded = try! JSONDecoder().decode(Sample.self, from: json)
//
//



// MARK: - 3. Dependency injection


//MARK: - 4. Configurable Wrappers
// Used to add some business logics into to property value
@propertyWrapper
struct Scores {
  private let minValue = 0
  private let maxValue = 100
  private var value: Int
  
  init(wrappedValue value: Int) {
    self.value = value
  }
  
  var wrappedValue: Int {
    get {
      // Set the constraints for value of score is between 0 and 100
      return max(min(value, maxValue), minValue)
    }
    set {
      value = newValue
    }
  }
}


struct ScoreInInt {
  @Scores
  var myScore: Int = 0
}

var scoreInInt = ScoreInInt()
print(scoreInInt.myScore) // prints the default score value as '0'

scoreInInt.myScore = 55
print(scoreInInt.myScore) // prints new score value as '55'


//-----------------------------------------------------------------------------
// Generic contraints for a value within a defined closed range
@propertyWrapper
struct Constrained<Value: Comparable> {
  private var range: ClosedRange<Value>
  private var value: Value
  
  
  init(wrappedValue value: Value, _ range: ClosedRange<Value>) {
    self.value = value
    self.range = range
  }
  
  var wrappedValue: Value {
    get {
      // return the value within a defined min and max values
      return max(min(value, range.upperBound), range.lowerBound)
    }
    set {
      value = newValue 
    }
  }
}


struct Score {
  // Set the constraints for value of score is between 0 and 100
  @Constrained(0...100)
  var myScore: Int = 0 // default value for score is set to '0'

}

var score = Score()
print(score.myScore) // prints default score '0'

score.myScore = 99
print(score.myScore) // prints new score as '99'

//MARK: -  Gaining Access to the Wrapper Itself
@propertyWrapper
struct Email<Value: StringProtocol> {
  var value: Value?
  
  init(wrappedValue value: Value?) {
    self.value = value
  }
  
  var wrappedValue: Value? {
    get {
      return validate(email: value) ? value : nil
    }
    set {
      value = newValue
    }
  }
  
  var projectedValue: Email<Value> { return self } // expose the wrapper
  
  private func validate(email: Value?) -> Bool {
    // return false if email is empty
    guard let email = email else { return false }
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    // return a bool after check the email syntax
    return emailPred.evaluate(with: email)
  }
}

// Property wrappers are not yet supported in top-level code
//@Email
//var email: String?
//

struct UserEmail {
  @Email
  var invalidEmail: String? = "Invalid"
  var validEmail: String? = "valid@test.com"
}

let userEmail = UserEmail()
print(userEmail.invalidEmail ?? "")  // prints 'nil'
print(userEmail.validEmail ?? "")   // prints 'valid@test.com'


// Gainning access to the wrapper itself
public struct Account {
  var firstName: String
  var lastName: String

  @Email
  var email: String?
}



let account = Account(firstName: "FirstName", lastName: "LastName", email: "Sample@test.com")


//extension Account: Equatable {
//  static func ==(lhs: Account, rhs: Account) -> Bool {
//    return lhs.email?.lowercased() == rhs.email?.lowercased()
//  }
//}

extension Email: Equatable {
  static func ==(lhs: Email, rhs: Email) -> Bool {
    return lhs.wrappedValue?.lowercased() == rhs.wrappedValue?.lowercased()
  }
}

extension Account: Equatable {
  public static func ==(lhs: Account, rhs: Account) -> Bool {
    return lhs._email == rhs._email
  }
}


account.email // Wrapped value (String)
account.$email.projectedValue // Wrapper (Email<String>)



//MARK: - How to implement a property wrapper?

@propertyWrapper
struct Wrapper<T> {
   var wrappedValue: T
  
  var projectedValue: Wrapper<T> { return self } // expose the wrapper
  
  func Sample() {
    print("Sample inside the wrapper")
  }
}
// use the attribute `@Wrapper` at the property declaration site
struct HasWrapper {
  @Wrapper var x: Int
  
  func SampleHasWrapper() {
    // access the wrapper type by adding an underscore to the variable name
    _x.Sample()    // _x is an instance of `Wrapper<T>`
  }
  
  func WaysToAccessWrapper() {
    print(x)  // `wrappedValue`
    print(_x) // wrapper type itself
    print($x) // `projectedValue`
  }
  
}

let a = HasWrapper(x: 0)
print(a)
// calling instance of wrapper type outside the struct `HasWrapper` will cause error, as here
// a._x.Sample()
// Reason: the synthesized wrapper has a `private` access control level.

// Solution: We can override this access control via
// using `projection` inside the Wrapper as `projectedValue`
// and use `$` as the syntactic sugar to access the wrapper, as following:
let b = HasWrapper(x: 1)
b.$x.Sample() // Prints 'Sample inside the wrapper'


//  How to access a property wrapper, its wrapped value, and projection?
let c = HasWrapper(x: 2)
c.WaysToAccessWrapper()



// We can pass a default value to the wrapoper in 2 ways
struct HasWrapperWithInitialValue {
  @Wrapper var x = 1              // implicitly use inti(wrapperdValue:) to initialize `x` with 1
  @Wrapper(wrappedValue: 2) var y // explicitly initialize the value for y
}

let sample = HasWrapperWithInitialValue()
print(sample.x)
print(sample.y)


/*
 How property wrappers are synthesized by the Swift compiler?
 1. Swift code is parsed into the expressions tree by lib/Parse.
 https://github.com/apple/swift/blob/main/lib/Parse/ParseExpr.cpp

 2. ASTWalker traverses the tree and builds ASTContext out of it. Specifically, when the walker finds a property with the @propertyWrapper attribute, it adds this information to the context for later use.

 https://github.com/apple/swift/blob/2e65a14ed43bc959ce45aafbdfd3a3656f83f1cc/lib/AST/ASTWalker.cpp#L167
 https://github.com/apple/swift/blob/2e65a14ed43bc959ce45aafbdfd3a3656f83f1cc/lib/AST/ASTContext.cpp

 3. After ASTContext has been evaluated, it is now able to return property wrapper type info via getOriginalWrappedProperty() and getPropertyWrapperBackingPropertyInfo(), which are defined in Decl.cpp.
 https://github.com/apple/swift/blob/2e65a14ed43bc959ce45aafbdfd3a3656f83f1cc/lib/AST/Decl.cpp#L5758

 4. During the SIL generation phase, the backing storage for a property with an attached wrapper is generated SILGen.cpp.
 https://github.com/apple/swift/blob/a05f787a9228bb7e7b51e31480e968d0cca51a95/lib/SILGen/SILGen.cpp#L1145
 
 */

//MARK: - Limitations of property wrapper
/*
1. No error handling:
  - wrapped value is a property, we cant not maked its `getter` or `setter` as `throws`.
  - we only return `nil` or crash the app with `fatalError()`
2. A property with a wrapper cannot have custom set or get method.
3. Multiple wrappers  for a property is not allowed.
 Example:
 @CaseInsensitive
 @Email
       var email: String?
 4. Property wrappers are not yet supported in top-level code (as of Swift 5.1)
 5. A property with a wrapper cannot be overridden in a subclass.
 6. A property with a wrapper cannot be lazy, @NSCopying, @NSManaged, weak, or unowned.
 7. `wrappedValue`, `init(wrappedValue:)` and `projectedValue` must have the same access control level
    as the wrapper type itself.
 8. A property with a wrapper cannot be declared in a protocol or an extension.
 9. Property wrappers require Swift 5.1, Xcode 11 and iOS 13.
*/


/*
 How we can utilize property wrappers in our code?
 - Some property wrappers are already built in SwiftUI:
    @State, @Published, @ObservedObject, @EnvironmentObject and @Environment
 - Atomic property:https://www.vadimbulavin.com/swift-atomic-properties-with-property-wrappers/
 - Validation: https://github.com/SvenTiigi/ValidatedPropertyKit
 - UserDefaults: https://www.avanderlee.com/swift/property-wrappers/
 - Extended Codable: https://github.com/marksands/BetterCodable

 */


/* Notes:
 - The wrapper object must contain a non-static property called a `wrappedValue`
 - Better syntax for readability
 - Property wrapper allows us to define a custom type, that implements behavior from `get` and `set` methods, and reuse it everywhere.
*/


// Refereces:
// https://www.toptal.com/swift/wrappers-swift-properties
// https://medium.com/better-programming/property-wrappers-three-real-case-scenarios-bd3e60a7c1ae
// https://www.vadimbulavin.com/swift-5-property-wrappers/
