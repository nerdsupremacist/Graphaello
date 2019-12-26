//
//  GraphQLType+ConnectionEdgeType.swift
//  
//
//  Created by Mathias Quintero on 12/19/19.
//

import Foundation

extension Schema.GraphQLType {
    struct ConnectionEdgeType {
        let edgeField: Schema.GraphQLType.Field
        let edgeType: Schema.GraphQLType
        let nodeField: Schema.GraphQLType.Field

        let pageInfoField: Schema.GraphQLType.Field
        let pageInfoType: Schema.GraphQLType
        let cursorField: Schema.GraphQLType.Field
        let nextPageField: Schema.GraphQLType.Field
    }

    func connectionEdgeType(using api: API) throws -> Schema.GraphQLType.ConnectionEdgeType? {
        guard let edgeField = fields?["edges"], let pageInfoField = fields?["pageInfo"] else { return nil }
        guard case .complex(let definition, let ofType) = edgeField.type,
            case .list = definition.kind else {

            return nil
        }
        let edgeType = api[ofType.underlyingTypeName]?.graphQLType ?! fatalError("Expected Type to exist")
        let pageInfoType = api[pageInfoField.type.underlyingTypeName]?.graphQLType ?! fatalError("Expected Type to exist")

        guard let nodeField = edgeType.fields?["node"],
            let cursorField = pageInfoType.fields?["endCursor"],
            let nextPageField = pageInfoType.fields?["hasNextPage"] else { return nil }

        return ConnectionEdgeType(edgeField: edgeField,
                                  edgeType: edgeType,
                                  nodeField: nodeField,
                                  pageInfoField: pageInfoField,
                                  pageInfoType: pageInfoType,
                                  cursorField: cursorField,
                                  nextPageField: nextPageField)
    }
}
