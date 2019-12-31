//
//  Preparator.swift
//  
//
//  Created by Mathias Quintero on 31.12.19.
//

import Foundation

protocol Preparator {
    func prepare(assembled: Project.State<Stage.Assembled>,
                 using apollo: ApolloReference) throws -> Project.State<Stage.Prepared>
}
