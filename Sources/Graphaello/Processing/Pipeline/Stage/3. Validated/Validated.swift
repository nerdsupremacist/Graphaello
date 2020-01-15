//
//  Validated.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Stage {

    // The GraphQL Paths have been type checked and bundled with the respective Types
    // + All default arguments have been injected.
    enum Validated: GraphQLStage {
        enum TypeReference {
            case concrete(Schema.GraphQLType.Field.TypeReference)
            case field(Schema.GraphQLType.Field.TypeReference)
        }

        struct Component {
            enum Reference {
                enum Casting {
                    case up
                    case down
                }

                case field(Schema.GraphQLType.Field)
                case fragment
                case casting(Casting)
                case type(Schema.GraphQLType.Field.TypeReference)
            }
            
            let reference: Reference
            let underlyingType: Schema.GraphQLType
            let parsed: Parsed.Component
        }

        struct Path {
            let parsed: Parsed.Path
            let api: API
            let target: Schema.GraphQLType
            let components: [Component]
        }
        
        static let pathKey = Context.Key.validated
    }

}

extension Stage.Validated.Component {

    var type: Stage.Validated.TypeReference {
        switch reference {
        case .field(let field):
            return .field(field.type)
        case .fragment, .casting:
            return .field(.concrete(.init(kind: underlyingType.kind, name: underlyingType.name)))
        case .type(let type):
            return .concrete(type)
        }
    }
    
    var fieldType: Schema.GraphQLType.Field.TypeReference? {
        guard case .field(let fieldType) = type else { return nil }
        return fieldType
    }
    
}

extension Stage.Validated.TypeReference {

    var type: Schema.GraphQLType.Field.TypeReference {
        switch self {
        case .concrete(let type):
            return type
        case .field(let type):
            return type
        }
    }

}

extension Context.Key where T == Stage.Validated.Path? {
    
    static let validated = Context.Key<Stage.Validated.Path?>()
    
}

extension Stage.Validated.Path {

    var returnType: Schema.GraphQLType.Field.TypeReference {
        return components.returnType
    }

}

extension RandomAccessCollection where Element == Stage.Validated.Component {
    
    var returnType: Schema.GraphQLType.Field.TypeReference {
        guard let last = last else { fatalError() }
        return dropLast()
            .reversed()
            .reduce(last.type) { returnType, component in
                switch returnType {
                case .concrete:
                    return returnType
                case .field(let returnType):
                    return component.embed(returnType: returnType)
                }
            }
            .type
    }
    
}

extension Stage.Validated.Component {

    fileprivate func embed(returnType: Schema.GraphQLType.Field.TypeReference) -> Stage.Validated.TypeReference {
        switch type {
        case .concrete(let type):
            return .concrete(type.embed(returnType: returnType))
        case .field(let type):
            return .field(type.embed(returnType: returnType))
        }
    }

}

extension Schema.GraphQLType.Field.TypeReference {
    
    fileprivate func embed(returnType: Schema.GraphQLType.Field.TypeReference) -> Schema.GraphQLType.Field.TypeReference {
        switch (returnType, self) {
        case (.concrete, .concrete):
            return returnType
        case (.complex(let definition, let ofType), .concrete) where definition.kind == .nonNull:
            return ofType
        case (.complex, .concrete):
            return returnType
        case (.complex(let lhs, _), .complex(let rhs, _)) where lhs.kind == .nonNull && rhs.kind == .nonNull:
            return returnType
        case (_, .complex(let definition, let ofType)):
            return .complex(definition, ofType: ofType.embed(returnType: returnType))
        }
    }
    
}
