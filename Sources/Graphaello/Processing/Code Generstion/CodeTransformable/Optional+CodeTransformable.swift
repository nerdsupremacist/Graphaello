//
//  Optional+CodeTransformable.swift
//  Graphaello
//
//  Created by Mathias Quintero on 10.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation
import Stencil

extension Optional: CodeTransformable where Wrapped: CodeTransformable {
    func code(using context: Stencil.Context, arguments: [Any?]) throws -> String {
        return try self?.code(using: context, arguments: arguments) ?? ""
    }
}
