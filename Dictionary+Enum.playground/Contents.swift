
import Foundation

protocol StringEnumSubscript {
  var rawValue: String { get }
}

extension Dictionary {
  subscript(enumKey: StringEnumSubscript) -> Value? {
    get {
      if let key = enumKey.rawValue as? Key {
        return self[key]
      }
      return nil
    }
    set {
      if let key = enumKey.rawValue as? Key {
        self[key] = newValue
      }
    }
  }
}

// MARK: - Usage

enum JSONKey: String {
  case identifier = "id"
  case token
  case firstname = "first_name"
  case lastName = "last_name"
}

extension JSONKey: StringEnumSubscript { }


let userDictionary = [
  "first_name": "Cong",
  "last_name": "Le",
  "token": "sdadawfvsasd34123daaee",
  "id": "24243123123232123"
]


let firstName = userDictionary[JSONKey.firstname]
let lastName = userDictionary[JSONKey.lastName]

var newUser = userDictionary

newUser[JSONKey.token] = "different token"
newUser[JSONKey.lastName] = "John"
newUser[JSONKey.identifier] = "879"
