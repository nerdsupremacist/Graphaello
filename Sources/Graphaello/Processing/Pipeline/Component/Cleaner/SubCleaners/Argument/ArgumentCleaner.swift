//
//  ArgumentCleaner.swift
//  
//
//  Created by Mathias Quintero on 1/1/19.
//

import Foundation

protocol ArgumentCleaner {
    associatedtype Value
    func clean(resolved: Value, using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<Value>
}

extension ArgumentCleaner {

    func clean(resolved: Value) throws -> Value {
        return try clean(resolved: resolved, using: .empty).value
    }

}

extension ArgumentCleaner {

    func clean(resolved: Value?, using context: Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<Value?> {
        return try resolved
            .map { try clean(resolved: $0, using: context).map(transform: Optional.some) } ??
            context.result(value: nil)
    }

}
