//
//  SwiftCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

protocol SwiftCodeTransformable {
    func code(using context: Context, arguments: [Any?]) throws -> String
}

extension SwiftCodeTransformable {
    
    func code(using environment: Environment) throws -> String {
        return try environment.renderTemplate(name: "SwiftCodeTransformable.swift.stencil", context: ["value" : self])
    }
    
}

extension SwiftCodeTransformable {
    
    func code(using context: Context, arguments: [Any?]) throws -> String {
        let name = String(describing: Self.self)
        return try context.render(template: "\(name).swift.stencil", context: [name.lowercased() : self])
    }
    
}
