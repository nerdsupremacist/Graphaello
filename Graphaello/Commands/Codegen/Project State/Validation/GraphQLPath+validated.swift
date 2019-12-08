//
//  GraphQLPath+validatedTypes.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/7/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Stage.Parsed.Path {

    func validated(apis: [API]) throws -> Stage.Validated.Path {
        let api = try apis[apiName] ?! GraphQLPathValidationError.apiNotFound(apiName, apis: apis)
        let targetType = try target.type(in: api)
        let initialResult = Result(path: [], type: .object(targetType))
        let validatedPath = try components.reduce(initialResult) { result, component in
            try component.validated(result: result, api: api)
        }

        let path: [Stage.Validated.Component]
        if case .object = validatedPath.type, validatedPath.path.last?.parsed != .fragment {
            path = validatedPath.path + [validatedPath.fragmentComponent()]
        } else {
            path = validatedPath.path
        }

        return Stage.Validated.Path(parsed: self, components: path)
    }

}

fileprivate struct Result {
    enum ResultType {
        case object(Schema.GraphQLType)
        case scalar(Schema.GraphQLType)

        var graphQLType: Schema.GraphQLType {
            switch self {
            case .object(let type):
                return type
            case .scalar(let type):
                return type
            }
        }
    }

    let path: [Stage.Validated.Component]
    let type: ResultType

    func fragmentComponent() -> Stage.Validated.Component {
        return .init(fieldType: .concrete(.init(kind: .scalar, name: type.graphQLType.name)),
                     underlyingType: type.graphQLType,
                     parsed: .fragment)
    }
}

extension Stage.Parsed.Component {

    fileprivate func validated(result: Result, api: API) throws -> Result {
        switch (self, result.type) {

        case (.property(let name), .object(let type)):
            let field = try type.fields?[name] ?! GraphQLPathValidationError.fieldNotFoundInType(name, type: type)
            if field.arguments.isEmpty {
                let type = try api[field.type.underlyingTypeName] ?!
                    GraphQLPathValidationError.typeNotFound(field.type.underlyingTypeName, api: api)

                let component = Stage.Validated.Component(fieldType: field.type, underlyingType: type.graphQLType, parsed: self)
                return Result(path: result.path + [component], type: type)
            } else {
                return try Stage.Parsed.Component.call(name, [:]).validated(result: result, api: api)
            }

        case (.fragment, .object):
            return Result(path: result.path + [result.fragmentComponent()],
                          type: result.type)

        case (.call(let name, let arguments), .object(let type)):
            let field = try type.fields?[name] ?! GraphQLPathValidationError.fieldNotFoundInType(name, type: type)
            let arguments = field.defaultArgumentDictionary.merging(arguments) { $1 }
            let type = try api[field.type.underlyingTypeName] ?!
                GraphQLPathValidationError.typeNotFound(field.type.underlyingTypeName, api: api)

            let component = Stage.Validated.Component(fieldType: field.type, underlyingType: type.graphQLType, parsed: .call(name, arguments))
            return Result(path: result.path + [component], type: type)

        case (_, .scalar(let type)):
            throw GraphQLPathValidationError.cannotCallUseComponentForScalar(self, type: type)

        }
    }

}

extension Schema.GraphQLType.Field {

    fileprivate var defaultArgumentDictionary: [String : Graphaello.Argument] {
        let baseDictionary = Dictionary(uniqueKeysWithValues: arguments.map { ($0.name, $0) })
        return baseDictionary.mapValues { argument in
            argument
                .defaultValue
                .map { _ in
                    // TODO: Find out how to insert the default values
                    .argument(.forced)
//                    GraphQLPath.Component.Argument.argument(.withDefault())
                } ?? .argument(.forced)
        }
    }

}

extension API {

    fileprivate subscript(name: String) -> Result.ResultType? {
        if let type = types[name] {
            return .object(type)
        }

        if let type = scalars[name] {
            return .scalar(type)
        }

        return nil
    }

}
