//
//  FieldNameCleaner.swift
//  
//
//  Created by Mathias Quintero on 01.01.20.
//

import Foundation


protocol FieldNameCleaner {
    associatedtype Value
    func clean(resolved: Value, using context: Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<Value>
}

extension FieldNameCleaner {

    func clean(resolved: Value) throws -> Value {
        return try clean(resolved: resolved, using: .empty).value
    }

}

extension FieldNameCleaner {

    func clean(resolved: Value?, using context: Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<Value?> {
        return try resolved
            .map { try clean(resolved: $0, using: context).map(transform: Optional.some) } ??
            context.result(value: nil)
    }

}
