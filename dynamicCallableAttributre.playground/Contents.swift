
/// Apply attribute to struct to turn its instance become a type of callable function
@dynamicCallable
struct TelephoneExchange {
  func dynamicallyCall(withArguments phoneNumber: [Int]) {
    if phoneNumber == [4, 1, 1] {
      print("I belongs to array of ints")
    } else {
      print("I am outside the array")
    }
  }
}

let dial = TelephoneExchange()
// use the dynamic method call
dial(4,1,1) // I belongs to array of ints

dial(4,1,2) // I am outside the array

// directly call the method inside the struct
dial.dynamicallyCall(withArguments: [4,1,1])// I belongs to array of ints
