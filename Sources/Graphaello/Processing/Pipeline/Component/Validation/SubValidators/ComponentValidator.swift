//
//  ComponentValidator.swift
//  Graphaello
//
//  Created by Mathias Quintero on 08.12.19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol ComponentValidator {
    func validate(component: Stage.Parsed.Component,
                  using context: ComponentValidation.Context) throws -> ComponentValidation.Result
}
