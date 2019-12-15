//
//  CollectedPath+object.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension CollectedPath.Valid {

    func object(propertyName: String) -> GraphQLObject {
        switch self {
        case .scalar(let field):
            return GraphQLObject(components: [field : .scalar(propertyNames: [propertyName])], fragments: [:])
        case .object(let field, let valid):
            return GraphQLObject(components: [field : .object(valid.object(propertyName: propertyName))], fragments: [:])
        case .fragment(let fragment):
            return GraphQLObject(components: [:], fragments: [propertyName : fragment])
        }
    }
    
}
