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
    "genres": ["Animation", "Comedy", "Drama"],
    "countries": {"Canada":"CA", "United States":"US"},
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
