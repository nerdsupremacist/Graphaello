import Foundation

struct BasicAliasStateMatcher: AliasStateMatcher {
    
    func match(query: GraphQLQuery, to aliased: GraphQLQuery) -> GraphQLQuery {
        return GraphQLQuery(name: query.name,
                            api: query.api,
                            components: match(components: query.components, to: aliased.components))
    }
    
    private func match(components: [GraphQLField : GraphQLComponent],
                       to aliased: [GraphQLField : GraphQLComponent]) -> [GraphQLField : GraphQLComponent] {
        
        let mapped = components.map { element in
            guard let aliased = aliased.first(where: { $0.key.field == element.key.field }) else { return element }
            return (match(field: element.key, to: aliased.key), match(component: element.value, to: aliased.value))
        } as [(GraphQLField, GraphQLComponent)]
        
        return Dictionary(uniqueKeysWithValues: mapped)
    }
    
    private func match(field: GraphQLField, to aliased: GraphQLField) -> GraphQLField {
        return aliased
    }
    
    private func match(component: GraphQLComponent, to aliased: GraphQLComponent) -> GraphQLComponent {
        switch (component, aliased) {
        case (.scalar, .scalar):
            return .scalar
        case (.object(let object), .object(let aliased)):
            return .object(match(object: object, to: aliased))
        default:
            fatalError()
        }
    }
    
    private func match(object: GraphQLObject, to aliased: GraphQLObject) -> GraphQLObject {
        return GraphQLObject(components: match(components: object.components, to: aliased.components),
                             fragments: object.fragments,
                             typeConditionals: object.typeConditionals.mapValues { typeConditional in
                                guard let aliased = aliased.typeConditionals[typeConditional.type.name] else { return typeConditional }
                                return GraphQLTypeConditional(type: typeConditional.type,
                                                              object: match(object: typeConditional.object, to: aliased.object))
                             },
                             arguments: object.arguments)
    }
    
}
