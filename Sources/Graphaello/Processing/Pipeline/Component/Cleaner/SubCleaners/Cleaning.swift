//
//  File.swift
//  
//
//  Created by Mathias Quintero on 1/1/19.
//

import Foundation

enum Cleaning {

    struct Context {
        private let nameMap: [String : GraphQLArgument]
        private let fieldMap: [Schema.GraphQLType.Field : [String : GraphQLArgument]]
    }

    struct Result<Value> {
        let value: Value
        fileprivate let context: Context
    }

}

extension Cleaning.Context {
    static let empty = Cleaning.Context(nameMap: [:], fieldMap: [:])
}

extension Cleaning.Context {

    func result<T>(value: T) -> Cleaning.Result<T> {
        return Cleaning.Result(value: value, context: self)
    }

}

extension SubCleaner {

    func clean<V>(resolved: Value, using result: Cleaning.Result<V>) throws -> Cleaning.Result<Value> {
        return try clean(resolved: resolved, using: result.context)
    }

}

extension Cleaning.Result {

    func map<T>(transform: (Value) throws -> T) rethrows -> Cleaning.Result<T> {
        return Cleaning.Result(value: try transform(value), context: context)
    }

    func flatMap<T>(transform: (Value, Cleaning.Context) throws -> Cleaning.Result<T>) rethrows -> Cleaning.Result<T> {
        return try transform(value, context)
    }

}

extension Sequence {
    func collect<V>(using context: Cleaning.Context,
                    transform: (Element, Cleaning.Context) throws -> Cleaning.Result<V>) rethrows -> Cleaning.Result<[V]> {

        return try reduce(Cleaning.Result(value: [], context: context)) { result, element in
            try transform(element, result.context).map { result.value + [$0] }
        }
    }

    func collect<V>(using context: Cleaning.Context,
                    transform: (Element, Cleaning.Context) throws -> Cleaning.Result<V>) rethrows -> Cleaning.Result<OrderedSet<V>> {

        return try reduce(Cleaning.Result(value: [], context: context)) { result, element in
            try transform(element, result.context).map { result.value + [$0] }
        }
    }

    func collect<T, V>(using result: Cleaning.Result<T>,
                       transform: (Element, Cleaning.Context) throws -> Cleaning.Result<V>) rethrows -> Cleaning.Result<[V]> {

        return try collect(using: result.context, transform: transform)
    }
}

extension Dictionary {
    func collect<V>(using context: Cleaning.Context,
                    transform: (Value, Cleaning.Context) throws -> Cleaning.Result<V>) rethrows -> Cleaning.Result<[Key : V]> {

        return try reduce(Cleaning.Result(value: [:], context: context)) { result, element in
            try transform(element.value, result.context).map { result.value.merging([element.key : $0]) { $1 } }
        }
    }

    func collect<T, V>(using result: Cleaning.Result<T>,
                       transform: (Value, Cleaning.Context) throws -> Cleaning.Result<V>) rethrows -> Cleaning.Result<[Key : V]> {

        return try collect(using: result.context, transform: transform)
    }
}

private enum ClashResolutionStrategy {
    case prependResultType
    case prependFieldName
    case addNumber(Int)

    var next: ClashResolutionStrategy {
        switch self {
        case .prependResultType:
            return .prependFieldName
        case .prependFieldName:
            return .addNumber(0)
        case .addNumber(let number):
            return .addNumber(number + 1)
        }
    }
}

extension Cleaning.Context {

    static func + (lhs: Cleaning.Context, rhs: GraphQLArgument) -> Cleaning.Result<GraphQLArgument> {
        return lhs.appending(rhs, original: rhs, resolutionStrategy: nil)
    }

    private func appending(_ argument: GraphQLArgument,
                           original: GraphQLArgument,
                           resolutionStrategy: ClashResolutionStrategy?) -> Cleaning.Result<GraphQLArgument> {

        guard let similarName = nameMap[argument.name] else {
            let fieldMap = self.fieldMap
                .merging([argument.field : [original.name : argument]]) { $0.merging($1) { $1 } }
            return Cleaning.Result(value: argument,
                                   context: Cleaning.Context(nameMap: nameMap.merging([argument.name : argument]) { $1 },
                                                             fieldMap: fieldMap))
        }

        if similarName ~= argument {
            // Merge both arguments
            return Cleaning.Result(value: similarName, context: self)
        }

        // Rename and try again!
        let strategy = resolutionStrategy?.next ?? .prependResultType
        let newArgument = original.rename(using: strategy)
        return appending(newArgument, original: original, resolutionStrategy: strategy)
    }

}

extension Cleaning.Context {

    static func + (lhs: Cleaning.Context, rhs: Field) -> Cleaning.Result<Field> {
        switch rhs {
        case .direct:
            return lhs.result(value: rhs)
        case .call(let field, let arguments):
            let fieldMap = lhs.fieldMap[field] ?? [:]
            let arguments = arguments.map { argument in
                Field.Argument(name: argument.name,
                               value: argument.value,
                               queryArgumentName: fieldMap[argument.name]?.name ?? argument.name) } as [Field.Argument]

            return lhs.result(value: .call(field, arguments))
        }
    }

}

extension GraphQLArgument {

    fileprivate func rename(using strategy: ClashResolutionStrategy) -> GraphQLArgument {
        switch strategy {
        case .prependResultType:
            return with(name: "\(field.type.underlyingTypeName)_\(name)")
        case .prependFieldName:
            return with(name: "\(field.name)_\(name)")
        case .addNumber(let number):
            return with(name: "\(name)_\(number)")
        }
    }

    fileprivate func with(name: String) -> GraphQLArgument  {
        return GraphQLArgument(name: name, field: field, type: type, defaultValue: defaultValue, argument: argument)
    }

}

