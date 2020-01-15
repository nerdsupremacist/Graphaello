//
//  File.swift
//  
//
//  Created by Mathias Quintero on 1/15/20.
//

import Foundation

struct BasicOperationTypeValidator: OperationTypeValidator {

    func validate(operation: Operation,
                  using context: ComponentValidation.Context) throws -> Schema.GraphQLType.Field.TypeReference {

        return try validate(operation: operation, on: context.components.returnType)
    }

    func validate(operation: Operation,
                  on returnType: Schema.GraphQLType.Field.TypeReference) throws -> Schema.GraphQLType.Field.TypeReference {

        switch (returnType, operation) {
        case (.complex(let nonNullDefinition, let ofType), _) where nonNullDefinition.kind == .nonNull:
            return .complex(nonNullDefinition, ofType: try validate(operation: operation, on: ofType))

        case (.complex(let listDefinition, .concrete(let itemDefinition)), .compactMap) where listDefinition.kind == .list:
            return .complex(listDefinition,
                            ofType: .complex(.init(kind: .nonNull, name: nil),
                                             ofType: .concrete(itemDefinition)))

        case (.complex(let outerListDefinition, .complex(let nonNullDefinition, .complex(let innerListDefinition, .concrete(let itemDefinition)))), .flatten) where outerListDefinition.kind == .list && nonNullDefinition.kind == .list && innerListDefinition.kind == .list:
            return .complex(outerListDefinition, ofType: .concrete(itemDefinition))

        case (_, .withDefault), (_, .nonNull):
            return .complex(.init(kind: .nonNull, name: nil), ofType: returnType)

        default:
            fatalError()

        }
    }

}
