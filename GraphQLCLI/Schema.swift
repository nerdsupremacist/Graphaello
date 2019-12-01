//
//  Schema.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 29.11.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct Schema: Codable {
    struct GraphQLType: Codable {
        enum Kind: String, Codable, Equatable {
            case scalar = "SCALAR"
            case object = "OBJECT"
            case list = "LIST"
            case nonNull = "NON_NULL"
            case `enum` = "ENUM"
        }
        
        struct Field: Codable {
            enum CodingKeys: String, CodingKey {
                case name
                case arguments = "args"
                case type
            }
            
            indirect enum TypeReference: Codable {
                enum CodingKeys: String, CodingKey {
                    case ofType
                }
                
                struct Definition: Codable {
                    let kind: Kind
                    let name: String?
                }
                
                case concrete(Definition)
                case complex(Definition, ofType: TypeReference)
                
                init(from decoder: Decoder) throws {
                    let definition = try Definition(from: decoder)
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    if container.contains(.ofType),
                        let ofType = try container.decode(TypeReference?.self, forKey: .ofType) {
                        
                        self = .complex(definition,
                                        ofType: ofType)
                    } else {
                        self = .concrete(definition)
                    }
                }
                
                func encode(to encoder: Encoder) throws {
                    switch self {
                    case .concrete(let definition):
                        try definition.encode(to: encoder)
                    case .complex(let definition, let other):
                        try definition.encode(to: encoder)
                        var container = encoder.container(keyedBy: CodingKeys.self)
                        try container.encode(other, forKey: .ofType)
                    }
                }
            }
            
            struct Argument: Codable {
                let name: String
                let defaultValue: String?
                let `type`: TypeReference
            }
            
            let name: String
            let arguments: [Argument]
            let `type`: TypeReference
        }
        
        let name: String
        let kind: Kind
        let fields: [Field]?
    }

    struct TypeReference: Codable {
        let name: String
    }
    
    let types: [GraphQLType]
    let queryType: TypeReference
}

class API {
    let name: String
    
    let query: Schema.GraphQLType
    
    var types: [Schema.GraphQLType]
    
    init(name: String, schema: Schema) {
        self.name = name
        self.query = schema.types.first { $0.name == schema.queryType.name } ?! fatalError("Expected a query type")
        self.types = schema.types
            .filter { $0.includeInReport }
            .filter { $0.name != schema.queryType.name }
    }
}

extension Schema.GraphQLType {
    
    var includeInReport: Bool {
        return kind == .object && !name.starts(with: "__")
    }
    
}

extension Schema.GraphQLType.Field.TypeReference {

    func swiftType(api: String?) -> String {
        switch self {

        case .concrete(let definition):
            guard let name = definition.name else { return "Any" }
            guard let api = api, case .object = definition.kind else {
                return "\(name)?"
            }
            return "\(api).\(name)?"

        case .complex(let definition, let ofType):
            switch definition.kind {
            case .list:
                return "[\(ofType.swiftType(api: api))]?"
            case .nonNull:
                return String(ofType.swiftType(api: api).dropLast())
            case .scalar, .object, .enum:
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
    
}
