//
//  GraphQLCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 11.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

protocol GraphQLCodeTransformable: CodeTransformable {}

extension GraphQLCodeTransformable {
    
    func code(using context: Context, arguments: [Any?]) throws -> String {
        let name = String(describing: Self.self)
        return try context.render(template: "graphQL/\(name).graphql.stencil",
                                  context: [name.replacingOccurrences(of: "GraphQL", with: "").camelized : self])
    }
    
}
