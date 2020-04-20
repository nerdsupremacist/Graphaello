//
//  BasicPathValidator.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct BasicPathValidator: PathValidator {
    let validator: ComponentValidator
    
    func validate(path: Stage.Parsed.Path, using apis: [API]) throws -> Stage.Validated.Path {
        let api = try apis[path.apiName] ?! GraphQLPathValidationError.apiNotFound(path.apiName, apis: apis)
        let targetType = try path.target.type(in: api)
        
        let initialContext = ComponentValidation.Context.for(type: targetType, in: api)
        let validatedContext = try path.components.reduce(initialContext) { context, component in
            return try context + validator.validate(component: component, using: context)
        }

        let components: [Stage.Validated.Component]
        if validatedContext.type.graphQLType.kind.isFragment, validatedContext.components.last?.parsed != .fragment {
            components = validatedContext.components + [validatedContext.fragmentComponent()]
        } else {
            components = validatedContext.components
        }

        return Stage.Validated.Path(parsed: path, api: api, target: targetType, components: components)
    }
}

extension BasicPathValidator {
    
    init(validator: () -> ComponentValidator) {
        self.validator = validator()
    }
    
}
