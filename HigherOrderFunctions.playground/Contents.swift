import Foundation



//MARK: - Map
// loop over a collection and apply operation to each elements

/// map on Array
let someInts = [1,4,6,2]
let squaredThemAll = someInts.map { $0 * $0 }
print(squaredThemAll)

let adding10ForEach = someInts.map { $0 + 10 }
print(adding10ForEach)

// map on Dictionary
let someItems = ["laptop": 200.0, "key": 10.4]

let transformedItems = someItems.map { (key, value)  in
  return (key.capitalized, value + 10) // return a tuples with tranformed elements
}
print(transformedItems)

//MARK: - Filter
// loop over a collection and retrun an array containing only those elements that match an include condition

/// filter on Array
let arrayOfIntegers = [1,2,3,4,5,6,7,8,9]

let evenNumbers = arrayOfIntegers.filter { someInts -> Bool in
  return someInts % 2 == 0 // only return even numbers
}
print(evenNumbers)

/// filter on Dictionary
let items = ["laptop": 200.0, "key": 10.4, "car": 2000.12, "apple": 2.1]

let expensiveItems = items.filter { (itemName, itemPrice) -> Bool in
  itemPrice > 100
}
// or can be written as
let expensiveItemsAgain = items.filter { $1 > 100 }
// Note: $0 is the key, $1 is the value

print(expensiveItems)
print(expensiveItemsAgain)


/// filter on Set
let setOfFloats = [1.123, 4.123, 22.1, 7.1, 9.1]
let moreThanFive = setOfFloats.filter { $0 > 5 }
print(moreThanFive)


// MARK: - Reduce
// use to combine all items in a collection to create a single new value

/// reduce on Array
let ints = [4,5,6,11]
let sum = ints.reduce(0, { x, y in
  x + y
})

// or can be written as
let sumAgain = ints.reduce(0, {$0 + $1} )

// We can use reduce for operators: +, -, *, /
// +
let sumAgain2 = ints.reduce(0, +)

// -
let subtract = ints.reduce(0, -)

// *
let multiplicaiton = ints.reduce(0, *)

// /
let numberUsedForDivision = [9, 3]
let division = numberUsedForDivision.reduce(81, /)

// We can use reduce and + for concatenating string values
let someStrings = ["co", "ng", "Le"]


let combinedString = someStrings.reduce("", {$0 + $1})
print(combinedString)
// or can be written as
let combinedString2 = someStrings.reduce("", +)

/// reduce on Dictionary
let randomItems = ["laptop": 200.0, "key": 10.4, "car": 2000.12, "apple": 2.1]

let reducedItemNameDictionary = randomItems.reduce("Random items are: ") { (result, tupleOfKeyAndValue) in
  return result + tupleOfKeyAndValue.key + " "
}
print(reducedItemNameDictionary)

// or it can be written as
let reducedKey = randomItems.reduce("Items are: ") { $0 + $1.key + " " }
print(reducedKey)

let reducedItemPriceInDictionary = randomItems.reduce(0) { (result, tupleOfKeyAndValue) in
  return result + tupleOfKeyAndValue.value
}
print("Total price of all items is: \(reducedItemPriceInDictionary)")

// or it can be written as
let reducedValue = randomItems.reduce(0, { $0 + $1.value})
print("Total price is: \(reducedValue)")


/// reduce on Set
let randomSet: Set = [12.1, 9.1, 33.3]
let reducedSet = randomSet.reduce(0.0) { $0 + $1 }
print(reducedSet)


// MARK: - FlatMap
// apple map for  each elements in the collection
// and then flat the initial collection

/// flatMap on Array
let stringColletions = [["asda", "xyz", "qwe"], ["asd", "zxc", "lkj"]]
let flattenCollection = stringColletions.flatMap {
  $0.map {
    $0.uppercased()
  }
}
print(flattenCollection)


let stringPhrases = ["asda", "xyz", "qwe"]
let flattenPhase = stringPhrases.flatMap { $0.uppercased() }
print(flattenPhase)


/// flatMap on array of dictionaries

let arrayOfDicts = [
  ["key": 123, "Key2": 11],
  ["key3": 13, "key4": 98]
]

let flattenDict = arrayOfDicts.flatMap { $0 }
print(flattenDict)

// flatmap by filtering or mapping
let collecctions = [
  [5, 2, 7],
  [1, 4, 8]
]

let onlyEven = collecctions.flatMap { array in
  array.filter { $0 % 2 == 0 }
}

print(onlyEven)

//MARK: - CompactMap
// work like flatMap but remove all nil values

let randomPhase = "sdasd asd asda a dewr"
let charaters = randomPhase.compactMap { return $0 }
print(charaters)

let randomThings = [5, nil, 12, nil]
let compactedThings = randomThings.compactMap { $0 }
print(compactedThings)

let randomStrings: [String?] = ["Cong", nil, "Le", nil]
let compactedString = randomStrings.compactMap { $0 }
print(compactedString)
