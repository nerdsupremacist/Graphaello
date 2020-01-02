//
//  AnyFieldNameCleaner.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

extension FieldNameCleaner {

    func any() -> AnyFieldNameCleaner<Value> {
        return AnyFieldNameCleaner(self)
    }

}

struct AnyFieldNameCleaner<T>: FieldNameCleaner {
    let _clean: (T, Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<T>

    init<C: FieldNameCleaner>(_ cleaner: C) where C.Value == T {
        _clean = cleaner.clean
    }

    func clean(resolved: T, using context: Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<T> {
        return try _clean(resolved, context)
    }
}
