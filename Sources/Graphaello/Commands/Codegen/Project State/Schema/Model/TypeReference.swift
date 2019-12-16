//
//  TypeReference.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Schema {

    struct TypeReference: Codable {
        let name: String
    }

}

extension Schema.GraphQLType.Field {

    indirect enum TypeReference: Equatable, Hashable {
        case concrete(Definition)
        case complex(Definition, ofType: TypeReference)
    }

}

extension Schema.GraphQLType.Field.TypeReference {
    
    var underlyingTypeName: String {
        switch self {
        case .concrete(let definition):
            return definition.name ?? "Any"
        case .complex(_, let ofType):
            return ofType.underlyingTypeName
        }
    }
    
    var graphQLType: String {
        switch self {

        case .concrete(let definition):
            return definition.name ?? "Any"

        case .complex(let definition, let ofType):
            switch definition.kind {
            case .list:
                return "[\(ofType.graphQLType)]"
            case .nonNull:
                return "\(ofType.graphQLType)!"
            case .scalar, .object, .enum, .interface, .inputObject, .union:
                // TODO: What should we do with interfaces, union types, etc.
                return ofType.graphQLType
            }
        }
    }

    func swiftType(api: String?) -> String {
        switch self {

        case .concrete(let definition):
            guard let name = definition.name else { return "Any" }
            // TODO: What should we do with interfaces, union types, etc.
            guard let api = api, case .object = definition.kind else {
                switch name {
                case "Boolean":
                    return "Bool?"
                case "DateTime":
                    return "Date?"
                case "URI":
                    return "URL?"
                case "ID":
                    return "String?"
                case "HTML":
                    return "String?"
                default:
                    return "\(name)?"
                }
            }
            return "\(api).\(name)?"

        case .complex(let definition, let ofType):
            switch definition.kind {
            case .list:
                return "[\(ofType.swiftType(api: api))]?"
            case .nonNull:
                return String(ofType.swiftType(api: api).dropLast())
            case .scalar, .object, .enum, .interface, .inputObject, .union:
                // TODO: What should we do with interfaces, union types, etc.
                return ofType.swiftType(api: api)
            }
        }
    }

    var isFragment: Bool {
        switch self {
        case .concrete(let definition):
            return definition.kind != .scalar
        case .complex(_, let ofType):
            return ofType.isFragment
        }
    }

    var optional: Schema.GraphQLType.Field.TypeReference {
        switch self {
        case .concrete:
            return self
        case .complex(let definition, let ofType):
            switch definition.kind {
            case .nonNull:
                return ofType
            case .list, .scalar, .object, .enum, .interface, .inputObject, .union:
                return self
            }
        }
    }

}
