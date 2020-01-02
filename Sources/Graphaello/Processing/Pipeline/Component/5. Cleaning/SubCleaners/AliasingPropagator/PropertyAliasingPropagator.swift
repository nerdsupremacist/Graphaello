//
//  PropertyAliasingPropagator.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

protocol PropertyAliasingPropagator {
    func propagate(property: Property<Stage.Resolved>, from resolved: Struct<Stage.Resolved>) throws -> Property<Stage.Cleaned>
}
