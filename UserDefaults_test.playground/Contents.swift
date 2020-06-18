import UIKit

// UserDefaults is not for saving large bits of data, its not a database

let defaults = UserDefaults.standard

let dictionaryKey = "myDictionary"

defaults.set(50, forKey: "Brightness")
defaults.set(true, forKey: "TvOn")
defaults.set("Jervy", forKey: "PlayerName")
defaults.set(Date(), forKey: "LastLoggedIn")

let array = [1,2,3]
defaults.set(array, forKey: "myArray")

let dictionary = [
    "name" : "Jervy Umandap",
    "age" : "26",
    "country" : "PH"
]
defaults.set(dictionary, forKey: dictionaryKey)


let brightness = defaults.float(forKey: "Brightness")
let lastLoggedIn = defaults.object(forKey: "LastLoggedIn")
let myArray = defaults.array(forKey: "myArray") as! [Int]
let myDictionary = defaults.dictionary(forKey: dictionaryKey)

print(myDictionary!)
