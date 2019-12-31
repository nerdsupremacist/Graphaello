//
//  StructFragmentCollector.swift
//  Graphaello
//
//  Created by Mathias Quintero on 09.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol ResolvedStructCollector {
    func collect(from properties: [Property<Stage.Resolved>],
                 for validated: Struct<Stage.Validated>) throws -> StructResolution.Result<Struct<Stage.Resolved>>
}
