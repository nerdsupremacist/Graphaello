//
//  String+CodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 11.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

extension String: CodeTransformable {
    
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        return self
    }
    
}
