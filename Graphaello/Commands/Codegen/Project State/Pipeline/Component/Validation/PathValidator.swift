//
//  PathValidator.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol PathValidator {
    func validate(path: Stage.Parsed.Path, using apis: [API]) throws -> Stage.Validated.Path
}
