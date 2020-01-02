//
//  Cleaning+Argument.swift
//  
//
//  Created by Mathias Quintero on 01.01.20.
//

import Foundation

extension Cleaning {
    
    enum FieldName { }
    
}

extension Cleaning.FieldName {
    
    struct Context {
        fileprivate let fragments: [String : GraphQLFragment]
    }
    
    struct Result<Value> {
        let value: Value
        fileprivate let context: Context
    }
    
}

extension Cleaning.FieldName.Context {
    static let empty = Cleaning.FieldName.Context(fragments: [:])
}

extension Cleaning.FieldName.Context {
    
    subscript(fragment: GraphQLFragment) -> GraphQLFragment {
        return fragments[fragment.name] ?! fatalError()
    }
    
}

extension Cleaning.FieldName.Context {

    func result<T>(value: T) -> Cleaning.FieldName.Result<T> {
        return Cleaning.FieldName.Result(value: value, context: self)
    }

}

extension Cleaning.FieldName.Context {
    
    static func + (lhs: Cleaning.FieldName.Context, rhs: GraphQLFragment) -> Cleaning.FieldName.Result<GraphQLFragment> {
        let context = Cleaning.FieldName.Context(fragments: lhs.fragments.merging([rhs.name : rhs]) { $1 })
        return Cleaning.FieldName.Result(value: rhs, context: context)
    }
    
}

extension FieldNameCleaner {

    func clean<V>(resolved: Value, using result: Cleaning.FieldName.Result<V>) throws -> Cleaning.FieldName.Result<Value> {
        return try clean(resolved: resolved, using: result.context)
    }
    
    func clean<V>(resolved: Value?, using result: Cleaning.FieldName.Result<V>) throws -> Cleaning.FieldName.Result<Value?> {
        return try clean(resolved: resolved, using: result.context)
    }

}


extension Cleaning.FieldName.Result {

    func map<T>(transform: (Value) throws -> T) rethrows -> Cleaning.FieldName.Result<T> {
        return Cleaning.FieldName.Result(value: try transform(value), context: context)
    }

    func flatMap<T>(transform: (Value, Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<T>) rethrows -> Cleaning.FieldName.Result<T> {
        return try transform(value, context)
    }

}

extension Sequence {
    func collect<V>(using context: Cleaning.FieldName.Context,
                    transform: (Element, Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<V>) rethrows -> Cleaning.FieldName.Result<[V]> {

        return try reduce(Cleaning.FieldName.Result(value: [], context: context)) { result, element in
            try transform(element, result.context).map { result.value + [$0] }
        }
    }

    func collect<T, V>(using result: Cleaning.FieldName.Result<T>,
                       transform: (Element, Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<V>) rethrows -> Cleaning.FieldName.Result<[V]> {

        return try collect(using: result.context, transform: transform)
    }
}

extension Dictionary {
    func collect<V>(using context: Cleaning.FieldName.Context,
                    transform: (Value, Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<V>) rethrows -> Cleaning.FieldName.Result<[Key : V]> {

        return try reduce(Cleaning.FieldName.Result(value: [:], context: context)) { result, element in
            try transform(element.value, result.context).map { result.value.merging([element.key : $0]) { $1 } }
        }
    }
    
    func collect<T, V>(using result: Cleaning.FieldName.Result<T>,
                       transform: (Value, Cleaning.FieldName.Context) throws -> Cleaning.FieldName.Result<V>) rethrows -> Cleaning.FieldName.Result<[Key : V]> {

        return try collect(using: result.context, transform: transform)
    }
}
