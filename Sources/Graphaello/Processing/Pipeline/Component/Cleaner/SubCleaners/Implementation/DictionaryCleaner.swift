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
            .collect(using: context) { try valueCleaner.clean(resolved: $0, using: $1) }
            .flatMap { dictionary, context in
                try dictionary.collect(using: context) { try keyCleaner.clean(resolved: $0, using: $1) }
            }
    }
}
