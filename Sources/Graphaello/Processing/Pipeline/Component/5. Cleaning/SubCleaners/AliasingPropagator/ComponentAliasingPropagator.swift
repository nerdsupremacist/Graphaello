//
//  ComponentAliasingPropagator.swift
//  
//
//  Created by Mathias Quintero on 02.01.20.
//

import Foundation

protocol ComponentAliasingPropagator {
    func propagate(components: [Stage.Validated.Component], from query: GraphQLQuery) throws -> [Stage.Cleaned.Component]
    func propagate(components: [Stage.Validated.Component], from object: GraphQLObject) throws -> [Stage.Cleaned.Component]
}
