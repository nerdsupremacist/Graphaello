//
//  PathResolver.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct PathResolver: ValueResolver {
    
    func resolve(value: Stage.Validated.Path,
                 in property: Property<Stage.Validated>,
                 using context: StructResolution.Context) throws -> StructResolution.Result<Stage.Resolved.Path> {
        
        guard value.components.last?.parsed == .fragment else {
            return .resolved(.init(validated: value, referencedFragment: nil))
        }
        
        let fragmentName = try StructResolution.FragmentName(typeName: property.type)
        guard let fragment = context[fragmentName] else { return .missingFragment }
        
        return .resolved(Stage.Resolved.Path(validated: value, referencedFragment: fragment))
    }
    
}
