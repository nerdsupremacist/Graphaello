//
//  Array+Structs+GraphQLStructs.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Array where Element == Struct {
    
    func graphQLStructs(apis: [API]) throws -> [GraphQLStruct] {
        return try graphQLStructs(apis: apis, existing: [])
    }
    
    private func graphQLStructs(apis: [API], existing: [GraphQLStruct]) throws -> [GraphQLStruct] {
        guard !isEmpty else { return existing }
        
        let result = try reduce(DecodingResult(decoded: [], remaining: [])) { result, element in
            try result + element.decode(using: apis, and: existing + result.decoded)
        }
        
        guard !result.decoded.isEmpty else {
            throw GraphQLFragmentResolverError.failedToDecodeAnyOfTheStructsDueToPossibleRecursion(self, resolved: existing)
        }
        
        return try result.remaining.graphQLStructs(apis: apis, existing: existing + result.decoded)
    }
}

extension Struct {
    
    fileprivate func decode(using apis: [API], and existing: [GraphQLStruct]) throws -> StructResult {
        let result = GraphQLStruct(definition: self, fragments: [], query: nil)
        return try properties.reduce(.decoded(result)) {
            try $0 + $1.decode(definition: self, using: apis, and: existing)
        }
    }
    
}

extension Property {
    
    fileprivate func decode(definition: Struct, using apis: [API], and existing: [GraphQLStruct]) throws -> PropertyResult {
        return try graphqlPath?.decode(definition: definition,
                                       property: self,
                                       using: apis,
                                       and: existing) ?? .notAGraphQLProperty
    }
    
}

extension GraphQLPath {
    
    fileprivate func decode(definition: Struct, property: Property, using apis: [API], and existing: [GraphQLStruct]) throws -> PropertyResult {
        let api = try apis[apiName] ?! GraphQLPathValidationError.apiNotFound(apiName, apis: apis)
        let target = try self.target.type(in: api)
        
        switch try path.object(type: property.type, existing: existing) {
        case .valid(let valid):
            switch self.target {
            case .object:
                return .fragment(GraphQLFragment(name: "\(definition.name)\(target.name)",
                                                 api: api,
                                                 target: target,
                                                 object: valid.object(propertyName: property.name)))
            case .query:
                return .query(GraphQLQuery(api: api,
                                           components: try valid.queryComponents(propertyName: property.name)))
            }
            

        case .missingFragment:
            return .missingFragment
            
        case .emptyPath:
            throw GraphQLFragmentResolverError.cannotResolveFragmentOrQueryWithEmptyPath(self)
        
        }
    }
    
}

extension Collection where Element == GraphQLPath.Component {
    
    fileprivate func object(type: String, existing: [GraphQLStruct]) throws -> GraphQLPathResult {
        return try reduce(.emptyPath) { try $0 + $1.object(type: type, existing: existing) }
    }
    
}

extension GraphQLPath.Component {
    
    fileprivate func object(type: String, existing: [GraphQLStruct]) throws -> GraphQLPathResult {
        switch self {
        case .property(let fieldName):
            return .valid(.scalar(.direct(fieldName)))
        
        case .fragment:
            let expectedFragmentName = type.replacingOccurrences(of: #"[\[\]\.\?]"#, with: "", options: .regularExpression)
            let fragments = existing.flatMap { $0.fragments }
            if let fragment = fragments.first(where: { $0.name == expectedFragmentName }) {
                return .valid(.fragment(fragment))
            } else {
                return .missingFragment
            }
            
        case .call(let fieldName, let arguments):
            return .valid(.scalar(.call(fieldName, arguments)))
            
        }
    }
    
}

private enum GraphQLPathResult {
    indirect enum Valid {
        case scalar(Field)
        case object(Field, Valid)
        case fragment(GraphQLFragment)
        
        static func + (lhs: GraphQLPathResult.Valid, rhs: @autoclosure () throws -> GraphQLPathResult) rethrows -> GraphQLPathResult {
            switch lhs {
            
            case .scalar(let field):
                switch try rhs() {
                case .valid(let valid):
                    return .valid(.object(field, valid))
                case .emptyPath:
                    fatalError("Cannot add an empty path to an alrady valid path")
                case .missingFragment:
                    return .missingFragment
                }

            case .object(let field, let valid):
                switch try valid + rhs() {
                case .valid(let valid):
                    return .valid(object(field, valid))
                case .emptyPath:
                    fatalError("Cannot add an empty path to an alrady valid path")
                case .missingFragment:
                    return .missingFragment
                }
            
            case fragment:
                fatalError("Unexpected extra value appended to fragment")
                
            }
            
        }
        
        func object(propertyName: String) -> GraphQLObject {
            switch self {
            case .scalar(let field):
                return GraphQLObject(components: [field : .scalar(propertyNames: [propertyName])], fragments: [])
            case .object(let field, let valid):
                return GraphQLObject(components: [field : .object(valid.object(propertyName: propertyName))], fragments: [])
            case .fragment(let fragment):
                return GraphQLObject(components: [:], fragments: [fragment])
            }
        }
        
        func queryComponents(propertyName: String) throws -> [Field : GraphQLComponent] {
            switch self {
            case .scalar(let field):
                return [field : .scalar(propertyNames: [propertyName])]
            case .object(let field, let valid):
                return [field : .object(valid.object(propertyName: propertyName))]
            case .fragment(let fragment):
                throw GraphQLFragmentResolverError.cannotIncludeFragmentsInsideAQuery(fragment)
            }
        }
    }
    
    case valid(Valid)
    case missingFragment
    case emptyPath
    
    static func + (lhs: GraphQLPathResult, rhs: @autoclosure () throws -> GraphQLPathResult) rethrows -> GraphQLPathResult {
        switch lhs {
            
        case .valid(let valid):
            return try valid + rhs()
            
        case .emptyPath:
            return try rhs()
            
        case .missingFragment:
            return .missingFragment
            
        }
    }
}

private enum PropertyResult {
    case fragment(GraphQLFragment)
    case query(GraphQLQuery)
    case missingFragment
    case notAGraphQLProperty
}

private enum StructResult {
    case decoded(GraphQLStruct)
    case remaining(Struct)
    
    static func + (lhs: StructResult, rhs: @autoclosure () throws -> PropertyResult) rethrows -> StructResult {
        guard case .decoded(let decoded) = lhs else { return lhs }
        switch try rhs() {
        case .fragment(let fragment):
            return .decoded(decoded + fragment)
        case .query(let query):
            return .decoded(decoded + query)
        case .missingFragment:
            return .remaining(decoded.definition)
        case .notAGraphQLProperty:
            return lhs
        }
    }
}

private struct DecodingResult {
    let decoded: [GraphQLStruct]
    let remaining: [Struct]
    
    static func + (lhs: DecodingResult, rhs: @autoclosure () throws -> StructResult) rethrows -> DecodingResult {
        switch try rhs() {
        case .decoded(let decoded):
            return DecodingResult(decoded: lhs.decoded + [decoded], remaining: lhs.remaining)
        case .remaining(let remaining):
            return DecodingResult(decoded: lhs.decoded, remaining: lhs.remaining + [remaining])
        }
    }
}
