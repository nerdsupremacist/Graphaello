//
//  StructResolver.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol StructResolver {
    associatedtype Resolved
    
    func resolve(validated: Struct<Stage.Validated>,
                 using context: StructResolution.Context) throws -> StructResolution.Result<Resolved>
}
