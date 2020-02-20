//
//  Dictionary+Ext.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/2/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import Foundation

protocol DictionaryType {
    associatedtype Key: Hashable
    associatedtype Value

    var isEmpty: Bool { get }
    func put(_ values: Self) -> Self
    func delete(_ values: Self) -> Self
}

extension Dictionary: DictionaryType {
    func put(_ values: [Key:Value]) -> [Key:Value] {
        return merging(values) { $1 }
    }

    func delete(_ values: [Key:Value]) -> [Key:Value] {
        return self.filter { !values.keys.contains($0.key) }
    }
}

extension Dictionary where Dictionary.Value: DictionaryType {
    func put(_ values: [Key:Value]) -> [Key:Value] {
        return merging(values) { (left: Value, right: Value)->Value in
            return left.put(right)
        }
    }

    func delete(_ values: [Key:Value]) -> [Key:Value] {
        let presented = values.filter { keys.contains($0.key) }
        return merging(presented) { (left: Value, right: Value)->Value in
            return left.delete(right)
        }.filter { !$0.value.isEmpty }
    }
}

extension Dictionary {
    func removing(at key: Key) -> Dictionary<Key, Value> {
        return self.filter { $0.key != key }
    }
}
