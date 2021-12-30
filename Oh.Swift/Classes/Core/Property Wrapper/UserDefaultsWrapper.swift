//
//  UserDefaultsWrapper.swift
//  AAT
//
//  Created by Allie on 2021/7/26.
//  Copyright © 2021 YiXue. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefaultsWrapper<T> {

    let key: String
    let defaultValue: T?

    public init(_ key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T? {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
            UserDefaults.standard.synchronize()
        }
    }
}

@propertyWrapper
public struct CodableUserDefaultsWrapper<T> where T: Codable {

    let key: String
    let defaultValue: T?

    public init(_ key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T? {
        get {
            guard let json = UserDefaults.standard.string(forKey: key),
                  let data = json.data(using: .utf8),
                  let value = try? JSONDecoder().decode(T.self, from: data) else {
                return defaultValue
            }
            return value
        }
        set {
            guard let newValue = newValue,
                  let data = try? JSONEncoder().encode(newValue),
                  let json = String(data: data, encoding: .utf8) else {
                UserDefaults.standard.removeObject(forKey: key)
                return
            }
            UserDefaults.standard.set(json, forKey: key)
        }
    }
}