//
//  ExtraValuesGraphQLCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 11.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

protocol ExtraValuesGraphQLCodeTransformable: GraphQLCodeTransformable {
    func arguments(from context: Stencil.Context, arguments: [Any?]) throws -> [String : Any]
}

extension ExtraValuesGraphQLCodeTransformable {

    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        let name = String(describing: Self.self)
        let dictionary = try self.arguments(from: context, arguments: arguments)
            .merging([name.replacingOccurrences(of: "GraphQL", with: "").camelized : self]) { $1 }
        return try context.render(template: "graphQL/\(name).graphql.stencil", context: dictionary)
    }

}
