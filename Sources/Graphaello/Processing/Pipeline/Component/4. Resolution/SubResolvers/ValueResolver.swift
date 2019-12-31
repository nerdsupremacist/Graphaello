//
//  Struct<Stage.Resolved>Resolver.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol ValueResolver {
    associatedtype Parent
    associatedtype Value
    associatedtype Resolved
    
    func resolve(value: Value,
                 in parent: Parent,
                 using context: StructResolution.Context) throws -> StructResolution.Result<Resolved>
}
