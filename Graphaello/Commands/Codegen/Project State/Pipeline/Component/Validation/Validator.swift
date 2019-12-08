//
//  Validator.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol Validator {
    func validate(parsed: Struct<Stage.Parsed>, using apis: [API]) throws -> Struct<Stage.Validated>
}
