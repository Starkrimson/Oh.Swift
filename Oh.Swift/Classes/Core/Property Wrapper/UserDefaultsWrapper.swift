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
