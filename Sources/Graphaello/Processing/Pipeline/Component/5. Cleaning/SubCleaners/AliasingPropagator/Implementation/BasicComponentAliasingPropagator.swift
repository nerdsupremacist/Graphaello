//
//  BasicComponentAliasingPropagator.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

struct BasicComponentAliasingPropagator: ComponentAliasingPropagator {
    
    func propagate(components: [Stage.Validated.Component],
                   from query: GraphQLQuery) throws -> [Stage.Cleaned.Component] {
        
        guard let first = components.first else { return [] }
        guard case .field(let field) = first.reference else {
            let rest = try propagate(components: Array(components.dropFirst()), from: query)
            return [Stage.Cleaned.Component(validated: first, alias: nil)] + rest
        }
        
        let matchingComponent = query.components.component(field: field, component: first) ?! fatalError("WTF!")
        let rest = try propagate(components: Array(components.dropFirst()), from: matchingComponent.1)
        return [Stage.Cleaned.Component(validated: first, alias: matchingComponent.0.alias)] + rest
    }
    
    func propagate(components: [Stage.Validated.Component],
                   from object: GraphQLObject) throws -> [Stage.Cleaned.Component] {
        
        guard let first = components.first else { return [] }
        
        switch first.reference {
        
        case .fragment, .casting(.up), .type:
            let rest = try propagate(components: Array(components.dropFirst()), from: object)
            return [Stage.Cleaned.Component(validated: first, alias: nil)] + rest
            
        case .field(let field):
            let matchingComponent = object.components.component(field: field, component: first) ?! fatalError("WTF!")
            let rest = try propagate(components: Array(components.dropFirst()), from: matchingComponent.1)
            return [Stage.Cleaned.Component(validated: first, alias: matchingComponent.0.alias)] + rest
            
        case .casting(.down):
            let typeConditional = object.typeConditionals[first.underlyingType.name] ?! fatalError("WTF!")
            let rest = try propagate(components: Array(components.dropFirst()), from: typeConditional.object)
            return [Stage.Cleaned.Component(validated: first, alias: nil)] + rest
        
        }
        
    }
    
    private func propagate(components: [Stage.Validated.Component],
                           from component: GraphQLComponent) throws -> [Stage.Cleaned.Component] {
        
        switch component {
        case .scalar:
            assert(components.isEmpty)
            return []
        case .object(let object):
            return try propagate(components: components, from: object)
        }
    }
    
}

extension Dictionary where Key == GraphQLField, Value == GraphQLComponent {
    
    fileprivate func component(field: Schema.GraphQLType.Field, component: Stage.Validated.Component) -> (GraphQLField, GraphQLComponent)? {
        let arguments = component.parsed.arguments
        return first { element in
            let elementArguments = element.key.fieldArguments
            return element.key.field.name == field.name &&
                arguments.allSatisfy { argument in
                    elementArguments.contains { $0.name == argument.name && $0.value == argument.value }
                }
        }
    }
    
}

extension Stage.Parsed.Component {
    
    fileprivate var arguments: [Field.Argument] {
        guard case .call(_, let arguments) = self else { return [] }
        return arguments
    }
    
}

extension GraphQLField {
    
    fileprivate var fieldArguments: [Field.Argument] {
        guard case .call(_, let arguments) = field else { return [] }
        return arguments
    }
    
}
