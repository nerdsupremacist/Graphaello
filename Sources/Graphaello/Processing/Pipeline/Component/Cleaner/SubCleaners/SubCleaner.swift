//
//  SubCleaner.swift
//  
//
//  Created by Mathias Quintero on 1/1/19.
//

import Foundation

protocol SubCleaner {
    associatedtype Value
    func clean(resolved: Value, using context: Cleaning.Context) throws -> Cleaning.Result<Value>
}

extension SubCleaner {

    func clean(resolved: Value) throws -> Value {
        return try clean(resolved: resolved, using: .empty).value
    }

}

extension SubCleaner {

    func clean(resolved: Value?, using context: Cleaning.Context) throws -> Cleaning.Result<Value?> {
        return try resolved
            .map { try clean(resolved: $0, using: context).map(transform: Optional.some) } ??
            context.result(value: nil)
    }

}
