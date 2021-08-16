import Foundation

struct GraphQLConnectionFragment: Hashable {
    let connection: Schema.GraphQLType
    let edgeType: Schema.GraphQLType
    let nodeFragment: GraphQLFragment
    let fragment: GraphQLFragment

    let isEdgesArrayNullable: Bool
    let areEdgesNullable: Bool
    let areNodesNullable: Bool
}

extension GraphQLConnectionFragment {
    
    init(connection: Schema.GraphQLType,
         nodeFragment: GraphQLFragment) throws {

        self.connection = connection
        self.nodeFragment = nodeFragment

        let connectionEdge = try connection.connectionEdgeType(using: nodeFragment.api) ?! fatalError()

        let pageInfoObject = GraphQLObject(components: [.direct(connectionEdge.cursorField) : .scalar, .direct(connectionEdge.nextPageField) : .scalar],
                                           fragments: [],
                                           typeConditionals: [:])

        let nodeObject = GraphQLObject(components: [:], fragments: [nodeFragment], typeConditionals: [:])

        let edgeObject = GraphQLObject(components: [.direct(connectionEdge.nodeField) : .object(nodeObject)],
                                        fragments: [],
                                        typeConditionals: [:])

        let connectionObject = GraphQLObject(components: [.direct(connectionEdge.edgeField) : .object(edgeObject),
                                                          .direct(connectionEdge.pageInfoField) : .object(pageInfoObject)],
                                             fragments: [],
                                             typeConditionals: [:])

        self.edgeType = connectionEdge.edgeType
        self.fragment = GraphQLFragment(name: "\(connection.name)\(nodeFragment.name)",
                                        api: nodeFragment.api,
                                        target: connection,
                                        object: connectionObject)

        self.isEdgesArrayNullable = connectionEdge.isEdgesArrayNullable
        self.areEdgesNullable = connectionEdge.areEdgesNullable
        self.areNodesNullable = connectionEdge.areNodesNullable
    }

}

extension Schema.GraphQLType.ConnectionEdgeType {

    fileprivate var isEdgesArrayNullable: Bool {
        switch edgeField.type {
        case .complex(let definition, _):
            return definition.kind != .nonNull
        default:
            return false
        }
    }

    fileprivate var areEdgesNullable: Bool {
        switch edgeField.type.optional {
        case .complex(let definition, let ofType) where definition.kind == .list:
            switch ofType {
            case .complex(let edgeDefinition, _):
                return edgeDefinition.kind != .nonNull
            default:
                return false
            }
        default:
            return false
        }
    }

    fileprivate var areNodesNullable: Bool {
        switch edgeType.fields?["node"]?.type {
        case .none:
            return false
        case .complex(let definition, _):
            return definition.kind != .nonNull
        case .concrete:
            return true
        }
    }

}
