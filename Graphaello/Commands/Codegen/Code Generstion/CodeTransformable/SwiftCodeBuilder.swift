//
//  SwiftCodeBuilder.swift
//  Graphaello
//
//  Created by Mathias Quintero on 10.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

@_functionBuilder
struct CodeBuilder {
    
    static func buildBlock(_ transformable: CodeTransformable) -> CodeTransformable {
        return transformable
    }
    
    static func buildBlock(_ transformables: CodeTransformable...) -> CodeTransformable {
        return transformables.map { AnyCodeTransformable(transformable: $0) }
    }
    
}
