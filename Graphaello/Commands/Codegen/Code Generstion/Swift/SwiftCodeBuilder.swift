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
struct SwiftCodeBuilder {
    
    static func buildBlock(_ transformable: SwiftCodeTransformable) -> SwiftCodeTransformable {
        return transformable
    }
    
    static func buildBlock(_ transformables: SwiftCodeTransformable...) -> SwiftCodeTransformable {
        return transformables.map { AnySwiftCodeTransformable(transformable: $0) }
    }
    
}
