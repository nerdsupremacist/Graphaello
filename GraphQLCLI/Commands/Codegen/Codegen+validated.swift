//
//  Codegen+validate.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 04.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Codegen {
    
    func validated() throws -> Codegen {
        return Codegen(apis: apis,
                       structs: try structs.map { try $0.validated(apis: apis) })
    }
    
}

extension Struct {
    
    fileprivate func validated(apis: [API]) throws -> Struct {
        return Struct(name: name,
                      properties: try properties.map { try $0.validated(apis: apis) })
    }
    
}

extension Property {
    
    fileprivate func validated(apis: [API]) throws -> Property {
        return Property(name: name, type: type, graphqlPath: try graphqlPath.map { try $0.validated(apis: apis) })
    }
    
}

extension GraphQLPath {
    fileprivate struct Result {
        enum ResultType {
            case object(Schema.GraphQLType)
            case scalar(Schema.GraphQLType)
        }
        
        let path: [Component]
        let type: ResultType
    }
    
    fileprivate func validated(apis: [API]) throws -> GraphQLPath {
        let api = try apis[apiName] ?! GraphQLPathValidationError.apiNotFound(apiName, apis: apis.map { $0.name })
        let targetType = try target.type(in: api)
        let initialResult = GraphQLPath.Result(path: [], type: .object(targetType))
        let validatedPath = try path.reduce(initialResult) { result, component in
            try component.validated(result: result, api: api)
        }
        return GraphQLPath(apiName: apiName, target: target, path: validatedPath.path)
    }
    
}

extension GraphQLPath.Component {
    
    fileprivate func validated(result: GraphQLPath.Result, api: API) throws -> GraphQLPath.Result {
        switch (self, result.type) {
            
        case (.property(let name), .object(let type)):
            let field = try type.fields?[name] ?! GraphQLPathValidationError.fieldNotFoundInType(name, type: type)
            if field.arguments.isEmpty {
                let type = try api[field.type.underlyingTypeName] ?!
                    GraphQLPathValidationError.typeNotFound(field.type.underlyingTypeName, api: api.name)
                
                return GraphQLPath.Result(path: result.path + [self],
                                          type: type)
            } else {
                return try GraphQLPath.Component.call(name, [:]).validated(result: result, api: api)
            }
            
        case (.fragment, .object):
            return GraphQLPath.Result(path: result.path + [self], type: result.type)
            
        case (.call(let name, let arguments), .object(let type)):
            let field = try type.fields?[name] ?! GraphQLPathValidationError.fieldNotFoundInType(name, type: type)
            let arguments = field.defaultArgumentDictionary.merging(arguments) { $1 }
            let type = try api[field.type.underlyingTypeName] ?!
                GraphQLPathValidationError.typeNotFound(field.type.underlyingTypeName, api: api.name)
            
            return GraphQLPath.Result(path: result.path + [.call(name, arguments)],
                                      type: type)
        
        case (_, .scalar(let type)):
            throw GraphQLPathValidationError.cannotCallUseComponentForScalar(self, type: type)
        
        }
    }
    
}

extension Schema.GraphQLType.Field {
    
    fileprivate var defaultArgumentDictionary: [String : GraphQLPath.Component.Argument] {
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

extension GraphQLPath.Target {
    
    fileprivate func type(in api: API) throws -> Schema.GraphQLType {
        switch self {
        case .query:
            return api.query
        case .object(let name):
            return try api.types[name] ?! GraphQLPathValidationError.typeNotFound(name, api: api.name)
        }
    }
    
}

extension API {
    
    fileprivate subscript(name: String) -> GraphQLPath.Result.ResultType? {
        if let type = types[name] {
            return .object(type)
        }
        
        if let type = scalars[name] {
            return .scalar(type)
        }
        
        return nil
    }
    
}

extension Array where Element == API {
    
    fileprivate subscript(api: String) -> Element? {
        return first { $0.name == api }
    }
    
}

extension Array where Element == Schema.GraphQLType {
    
    fileprivate subscript(name: String) -> Element? {
        return first { $0.name == name }
    }
    
}

extension Array where Element == Schema.GraphQLType.Field {
    
    fileprivate subscript(name: String) -> Element? {
        return first { $0.name == name }
    }
    
}
