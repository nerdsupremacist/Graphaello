//
//  GraphQLStage.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol GraphQLStage: StageProtocol where Information == Path? {
    associatedtype Path
}

extension Property where CurrentStage: GraphQLStage {

    var graphqlPath: CurrentStage.Path? {
        return info
    }

}
