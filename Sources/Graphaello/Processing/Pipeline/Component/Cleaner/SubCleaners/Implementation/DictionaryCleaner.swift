//
//  DictionaryCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct DictionaryCleaner<Key: Hashable, Value>: SubCleaner {
    let keyCleaner: AnyCleaner<Key>
    let valueCleaner: AnyCleaner<Value>

    func clean(resolved: [Key : Value], using context: Cleaning.Context) throws -> Cleaning.Result<[Key : Value]> {
        return try resolved
            .reduce(context.result(value: [:])) { result, element in
                let value = try valueCleaner.clean(resolved: element.value, using: result)
                let key = try keyCleaner.clean(resolved: element.key, using: value)
                return key.map { result.value.merging([$0 : value.value]) { $1 } }
            }
    }
}
