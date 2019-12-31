//
//  SwiftCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 06.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

protocol SwiftCodeTransformable: CodeTransformable {}

extension SwiftCodeTransformable {
    
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        let name = String(describing: Self.self)
        return try context.render(template: "swift/\(name).swift.stencil", context: [name.camelized : self])
    }
    
}
