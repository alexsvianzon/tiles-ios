//
//  UserDefaults.swift
//  Tiles
//
//  Created by Alexander Vianzon on 8/2/26.
//

import Foundation

//
//  This UserDefaults implementation is taken from/inspired by:
//  (https://www.vadimbulavin.com/advanced-guide-to-userdefaults-in-swift/)
//

protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension String: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}

struct Key: RawRepresentable {
    let rawValue: String
}

extension Key: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}

//  enum-like declaration - i like this!
//  don't forget to add all the keys to the storage

extension Key {
    static let isOnboardingCompleted: Key = "onboarding"
    static let levelSaveData: Key = "levels"
}

@propertyWrapper
struct UserDefault<T: PropertyListValue> {
    let key: Key
    
    var wrappedValue: T? {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? T }
        set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
    }
}

struct Storage {
    @UserDefault(key: .isOnboardingCompleted)
    var isOnboardingCompleted: Bool?
    
    @UserDefault(key: .levelSaveData)
    var levelSaveData: [String : [String : Int]]?
}
