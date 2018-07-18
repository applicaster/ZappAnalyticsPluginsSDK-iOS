//
//  Dictionary+Additions.swift
//  ZappPlugins
//
//  Created by Alex Zchut on 12/07/2016.
//  Copyright © 2016 Anton Kononenko. All rights reserved.
//

import Foundation

extension Dictionary {
    public func merge(_ dict: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var mutableCopy = self
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
}
