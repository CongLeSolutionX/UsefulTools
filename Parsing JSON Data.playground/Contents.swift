import UIKit

let json = """
[
  {
    "name": "Banana",
    "points": 200,
    "description": "A banana grown in Ecuador."
  },
  {
    "name": "Orange",
    "points": 100
  }
]
"""
//MARK: -  JSON -> Swift => Using Decodable protocol
// Examples of reading data from JSON.
/// `Codable` is a type alias for both`Encodable` and `Decodable` protocols
struct GroceryProduct: Codable {
    let name: String
    let points: Int
    let description: String? // Optional is used for non-required elements
}

let jsonData = json.data(using: .utf8)!
let products = try JSONDecoder().decode([GroceryProduct].self, from: jsonData)

print("We are having the following products:")
for product in products {
    print("\t\(product.name) (\(product.points) points)")
    if let description = product.description {
        print("\t\t\(description)")
    }
}

//MARK: -  Swift -> JSON => Using Encodable protocol
// Examples of loading data from Swift model to JSON
var newProduct = GroceryProduct(name: "Apple", points: 150, description: "Grown in California")

let jsonData2 = try JSONEncoder().encode(newProduct)
let json2 = String(data: jsonData2, encoding: .utf8)!
print("\n")
print("Converting Swift data model into JSON string format:")
print(json2)

// MARK: - What if Swift properties differ from JSON that refer to the same values?
// Solution: We will use CodingKeys
// Examples using coding keys to match JSON keys with the Swift properties.

let jsonUser = """
{
  "first_name": "Cong",
  "last_name": "Le",
  "country": "United States"
}
"""

struct User: Codable {
    let firstName: String
    let lastName: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case country
    }
}

let jsonUserData = jsonUser.data(using: .utf8)!
let user = try JSONDecoder().decode(User.self, from: jsonUserData)
print("\n")
print("Mapping JSON variables to Swift properties via using CodingKeys:\n")
print(user.firstName)
print(user.lastName)

// MARK: - Other Codable data types include:
// URL, Number, Bool, Array, Dictionary, Data, Null, other JSON objects

let jsonOtherTypes = """
{
  "name": "The Witcher",
  "season": 1,
  "rate": 9.3,
  "favorite": null,
  "genres": [
    "Animation",
    "Comedy",
    "Drama"
  ],
  "countries": {
    "Canada": "CA",
    "United States": "US"
  },
  "platform": {
    "name": "Netflix",
    "ceo": "Reed Hastings"
  },
  "url": "https://en.wikipedia.org/wiki/BoJack_Horseman"
}
"""
struct Show: Decodable {
    let name: String
    let season: Int
    let rate: Float
    let favorite: Bool?
    let genres: [String]
    let countries: Dictionary<String, String>
    let platform: Platform
    let url: URL
    
    struct Platform: Decodable {
        let name: String
        let ceo: String
    }
}
let jsonShowData = jsonOtherTypes.data(using: .utf8)!
let show = try JSONDecoder().decode(Show.self, from: jsonShowData)
print("\n")
print("Mapping different JSON variables to Swift properties:\n")
print(show)

// MARK: - Parsing Date type

// If milliseconds - nothing to do
let jsonMs = """
{
    "date": 519751611.12542897
}
"""
struct DateRecord: Decodable {
    let date: Date
}

let msData = jsonMs.data(using: .utf8)!
let msResult = try JSONDecoder().decode(DateRecord.self, from: msData)
print("\n")
print("Converting miliseconds to Date format:")
print(msResult.date)

// If iso8601 use DateEncodingStrategy
let jsonIso = """
{
  "date": "2017-06-21T15:29:32Z"
}
"""

let isoData = jsonIso.data(using: .utf8)!
let isoDecoder = JSONDecoder()
isoDecoder.dateDecodingStrategy = .iso8601

let isoResult = try isoDecoder.decode(DateRecord.self, from: isoData)
print("\n")
print("Converting iso8601 to Date format:")
print(isoResult.date)

// If non-standard use `DateFormatter`
let jsonNS = """
{
  "date": "2020-03-19"
}
"""

// Define custom DateForamtter
extension DateFormatter {
    static let yyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd" // which is matched with the format in JSON
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

let nsData = jsonNS.data(using: .utf8)!
let nsDecoder = JSONDecoder()
nsDecoder.dateDecodingStrategy = .formatted(DateFormatter.yyyMMdd)
let nsResult = try nsDecoder.decode(DateRecord.self, from: nsData)
print("\n")
print("Converting non-standard to Date format:")
print(nsResult.date)

// MARK: - Dictionary with Array
let jsonDict = """
{
  "employees": [
    {
      "firstName": "Kevin",
      "lastName": "Flynn",
      
    },
    {
      "firstName": "Allan",
      "lastName": "Bradley",
      
    },
    {
      "firstName": "Ed",
      "lastName": "Dillinger",
      
    }
  ]
}
"""

struct Company: Codable {
    let employees: [Employee]
}

struct Employee: Codable {
    let firstName: String
    let lastName: String
}

let dictData = jsonDict.data(using: .utf8)!
let dictDecoder = JSONDecoder()
let dictResult = try dictDecoder.decode(Company.self, from: dictData)

print("\n")
print("Converting a dictionary with an array:")
print(dictResult.employees[0].firstName)
print(dictResult.employees[0].lastName)

print(dictResult.employees[1].firstName)
print(dictResult.employees[1].lastName)

// MARK: - Parsing a dictionary with array of mixed data types
// Follow this link https://uwyg0quc7d.execute-api.us-west-2.amazonaws.com/prod/history
// to get the following JSON payload
let jsonTransaction = """
{
  "transactions": [
    {
      "id": 699519475,
      "type": "redeemed",
      "amount": "150",
      "processed_at": "2020-07-17T12:56:27-04:00"
    },
    {
      "id": 699519475,
      "type": "earned",
      "amount": "10",
      "description": "10 Stars earned",
      "processed_at": "2020-07-17T12:55:27-04:00"
    },
    {
      "id": 699519475,
      "type": "redeemed",
      "amount": "150",
      "processed_at": "2020-06-10T12:56:27-04:00"
    }
  ]
}
"""

struct History: Codable {
    let transactions: [Transaction]
}

struct Transaction: Codable {
    let id: Int
    let type: String
    let amount: String
    let date: Date
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type, amount
        case date = "processed_at"
        case description
    }
}

let jsonTransactionData = jsonTransaction.data(using: .utf8)!
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601
let company = try decoder.decode(History.self, from: jsonTransactionData)
print("\n")
print("Parsing transation payload:")
print(company.transactions[0])
