import Foundation

struct ObjectFieldCall: GraphQLCodeTransformable {
    let field: GraphQLField
    let component: GraphQLComponent
}

extension GraphQLObject {
    
    var objectFieldCalls: [ObjectFieldCall] {
        return components
            .sorted { $0.key.field.name < $1.key.field.name }
            .map { ObjectFieldCall(field: $0.key, component: $0.value) }
    }
    
}

extension GraphQLQuery {
    
    var objectFieldCalls: [ObjectFieldCall] {
        return components
            .sorted { $0.key.field.name < $1.key.field.name }
            .map { ObjectFieldCall(field: $0.key, component: $0.value) }
    }
    
}
