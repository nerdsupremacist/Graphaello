import Foundation

extension Cleaning {
    
    enum Argument { }
    
}

extension Cleaning.Argument {
    
    struct Context {
        private let nameMap: [String : GraphQLArgument]
        private let fieldMap: [Schema.GraphQLType.Field : [String : [Argument : GraphQLArgument]]]
    }

    struct Result<Value> {
        let value: Value
        fileprivate let context: Context
    }
    
}

extension Cleaning.Argument.Context {
    static let empty = Cleaning.Argument.Context(nameMap: [:], fieldMap: [:])
}

extension Cleaning.Argument.Context {

    func result<T>(value: T) -> Cleaning.Argument.Result<T> {
        return Cleaning.Argument.Result(value: value, context: self)
    }

}

extension ArgumentCleaner {

    func clean<V>(resolved: Value, using result: Cleaning.Argument.Result<V>) throws -> Cleaning.Argument.Result<Value> {
        return try clean(resolved: resolved, using: result.context)
    }

}

extension Cleaning.Argument.Result {

    func map<T>(transform: (Value) throws -> T) rethrows -> Cleaning.Argument.Result<T> {
        return Cleaning.Argument.Result(value: try transform(value), context: context)
    }

    func flatMap<T>(transform: (Value, Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<T>) rethrows -> Cleaning.Argument.Result<T> {
        return try transform(value, context)
    }

}

extension Sequence {
    func collect<V>(using context: Cleaning.Argument.Context,
                    transform: (Element, Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<V>) rethrows -> Cleaning.Argument.Result<[V]> {

        return try reduce(Cleaning.Argument.Result(value: [], context: context)) { result, element in
            try transform(element, result.context).map { result.value + [$0] }
        }
    }

    func collect<V>(using context: Cleaning.Argument.Context,
                    transform: (Element, Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<V>) rethrows -> Cleaning.Argument.Result<OrderedSet<V>> {

        return try reduce(Cleaning.Argument.Result(value: [], context: context)) { result, element in
            try transform(element, result.context).map { result.value + [$0] }
        }
    }

    func collect<T, V>(using result: Cleaning.Argument.Result<T>,
                       transform: (Element, Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<V>) rethrows -> Cleaning.Argument.Result<[V]> {

        return try collect(using: result.context, transform: transform)
    }
}

extension Dictionary {
    func collect<V>(using context: Cleaning.Argument.Context,
                    transform: (Value, Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<V>) rethrows -> Cleaning.Argument.Result<[Key : V]> {

        return try reduce(Cleaning.Argument.Result(value: [:], context: context)) { result, element in
            try transform(element.value, result.context).map { result.value.merging([element.key : $0]) { $1 } }
        }
    }

    func collect<T, V>(using result: Cleaning.Argument.Result<T>,
                       transform: (Value, Cleaning.Argument.Context) throws -> Cleaning.Argument.Result<V>) rethrows -> Cleaning.Argument.Result<[Key : V]> {

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

extension Cleaning.Argument.Context {

    static func + (lhs: Cleaning.Argument.Context, rhs: GraphQLArgument) -> Cleaning.Argument.Result<GraphQLArgument> {
        return lhs.appending(rhs, original: rhs, resolutionStrategy: nil)
    }

    private func appending(_ argument: GraphQLArgument,
                           original: GraphQLArgument,
                           resolutionStrategy: ClashResolutionStrategy?) -> Cleaning.Argument.Result<GraphQLArgument> {

        guard let similarName = nameMap[argument.name] else {
            let fieldMap = self.fieldMap
                .merging([argument.field : [original.name : [argument.argument : argument]]]) { $0.merging($1) { $0.merging($1) { $1 } } }
            let context =  Cleaning.Argument.Context(nameMap: nameMap.merging([argument.name : argument]) { $1 },
                                                     fieldMap: fieldMap)
            
            return Cleaning.Argument.Result(value: argument, context: context)
        }

        if similarName ~= argument {
            // Merge both arguments
            return Cleaning.Argument.Result(value: similarName, context: self)
        }

        // Rename and try again!
        let strategy = resolutionStrategy?.next ?? .prependResultType
        let newArgument = original.rename(using: strategy)
        return appending(newArgument, original: original, resolutionStrategy: strategy)
    }

}

extension Cleaning.Argument.Context {

    static func + (lhs: Cleaning.Argument.Context, rhs: Field) -> Cleaning.Argument.Result<Field> {
        switch rhs {
        case .direct:
            return lhs.result(value: rhs)
        case .call(let field, let arguments):
            let fieldMap = lhs.fieldMap[field] ?? [:]
            let arguments = arguments.map { argument in
                let argumentMap = fieldMap[argument.name] ?? [:]
                return Field.Argument(name: argument.name,
                                      value: argument.value,
                                      queryArgumentName: argumentMap[argument.value]?.name ?? argument.name)
            } as [Field.Argument]

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

