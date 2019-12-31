//
//  AnyCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

extension SubCleaner {

    func any() -> AnyCleaner<Value> {
        return AnyCleaner(self)
    }

}

struct AnyCleaner<T>: SubCleaner {
    let _clean: (T, Cleaning.Context) throws -> Cleaning.Result<T>

    init<C: SubCleaner>(_ cleaner: C) where C.Value == T {
        _clean = cleaner.clean
    }

    func clean(resolved: T, using context: Cleaning.Context) throws -> Cleaning.Result<T> {
        return try _clean(resolved, context)
    }
}
