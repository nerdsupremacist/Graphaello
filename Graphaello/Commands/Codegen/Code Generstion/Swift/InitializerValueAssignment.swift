//
//  InitializerValueAssignment.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import SwiftSyntax

struct InitializerValueAssignment: SwiftCodeTransformable {
    let name: String
    let expression: String?
}

extension GraphQLStruct {
    
    var initializerValueAssignments: [InitializerValueAssignment] {
        return definition.properties.map { property in
            switch property.graphqlPath?.target {
            case .some(.query):
                return InitializerValueAssignment(name: property.name,
                                                  expression: query?.path(attribute: property.name).map { ["data"] + $0 }.map { "GraphQL(\($0.joined(separator: ".")))" })
            case .some(.object(let type)):
                let fragment = fragments.first { $0.target.name == type }
                return InitializerValueAssignment(name: property.name,
                                                  expression: fragment?.object.path(attribute: property.name).map { [type.camelized] + $0 }.map { "GraphQL(\($0.joined(separator: ".")))" })
            case .none:
                return InitializerValueAssignment(name: property.name, expression: property.name)
            }
        }
    }
    
}

extension GraphQLQuery {
    
    func path(attribute name: String) -> [String]? {
        return components.first { component in
            component.value.path(attribute: name).map { [component.key.name] + $0 }
        }
    }
    
}

extension GraphQLObject {
    
    func path(attribute name: String) -> [String]? {
        if let fragment = fragments[name] {
            return ["fragments", fragment.name.camelized]
        }
        
        return components.first { component in
            component.value.path(attribute: name).map { [component.key.name] + $0 }
        }
    }
    
}

extension Field {
    
    var name: String {
        switch self {
        case .direct(let name):
            return name
        case .call(let name, _):
            return name
        }
    }
    
}

extension GraphQLComponent {
    
    func path(attribute name: String) -> [String]? {
        switch self {
        case .scalar(let propertyNames):
            return propertyNames.contains(name) ? [] : nil
        case .object(let object):
            return object.path(attribute: name)
        }
    }
    
}

extension Sequence {
    
    func first<T>(transform: (Element) -> T?) -> T? {
        for element in self {
            if let result = transform(element) {
                return result
            }
        }
        return nil
        
    }
    
}
