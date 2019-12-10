//
//  Array+SwiftCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 10.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

extension Array: SwiftCodeTransformable where Element: SwiftCodeTransformable {
    
    func code(using context: Context, arguments: [Any?]) throws -> String {
        return try context.render(template: "Array.swift.stencil", context: ["values" : self])
    }
    
}

extension Array {
    
    func code(using context: Context, arguments: [Any?]) throws -> [String] {
        return try compactMap { element in
            switch element {
            case let element as SwiftCodeTransformable:
                return try element.code(using: context, arguments: arguments)
            case let element as CustomStringConvertible:
                return element.description
            default:
                return nil
            }
        }
    }
    
}
