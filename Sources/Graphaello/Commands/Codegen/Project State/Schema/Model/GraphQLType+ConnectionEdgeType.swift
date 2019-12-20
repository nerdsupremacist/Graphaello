//
//  GraphQLType+ConnectionEdgeType.swift
//  
//
//  Created by Mathias Quintero on 12/19/19.
//

import Foundation

extension Schema.GraphQLType {
    struct ConnectionEdgeType {
        let edgeType: Schema.GraphQLType
        let nodeType: Schema.GraphQLType.Field.TypeReference
    }

    func connectionEdgeType(using api: API) throws -> Schema.GraphQLType.ConnectionEdgeType? {
        guard case .some(.complex(let definition, let ofType)) = fields?["edges"]?.type,
            case .list = definition.kind else {

            return nil
        }
        let edgeType = api[ofType.underlyingTypeName]?.graphQLType ?! fatalError()

        guard let nodeType = edgeType.fields?["node"]?.type else {
            return nil
        }

        return ConnectionEdgeType(edgeType: edgeType, nodeType: nodeType)
    }
}
