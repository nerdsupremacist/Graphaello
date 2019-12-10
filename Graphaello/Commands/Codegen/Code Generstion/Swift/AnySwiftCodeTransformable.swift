//
//  AnySwiftCodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 10.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

struct AnySwiftCodeTransformable: SwiftCodeTransformable {
    
    let _code: (Context, [Any?]) throws -> String
    
    init(transformable: SwiftCodeTransformable) {
        _code = transformable.code
    }
    
    func code(using context: Context, arguments: [Any?]) throws -> String {
        return try _code(context, arguments)
    }
}
