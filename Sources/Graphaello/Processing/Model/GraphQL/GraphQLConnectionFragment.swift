import Foundation

struct GraphQLConnectionFragment: Hashable {
    let connection: Schema.GraphQLType
    let edgeType: Schema.GraphQLType
    let nodeFragment: GraphQLFragment
    let fragment: GraphQLFragment
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
    }

}
