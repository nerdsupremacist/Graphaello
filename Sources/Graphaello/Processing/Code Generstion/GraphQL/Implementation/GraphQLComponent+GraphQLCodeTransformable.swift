//
//  GraphQLComponent+GraphQLCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 11.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

extension GraphQLComponent: ExtraValuesGraphQLCodeTransformable {
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any] {
        return [
            "object": object ?? false,
        ]
    }
}

extension GraphQLComponent {
    
    fileprivate var object: GraphQLObject? {
        guard case .object(let object) = self else { return nil }
        return object
    }
    
}
