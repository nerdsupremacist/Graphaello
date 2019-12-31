//
//  GraphQLStage.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol GraphQLStage: StageProtocol {
    associatedtype Path
    static var pathKey: Context.Key<Path?> { get }
}

extension Property where CurrentStage: GraphQLStage {

    var graphqlPath: CurrentStage.Path? {
        return context[CurrentStage.pathKey]
    }

}

extension Property where CurrentStage: GraphQLStage {
    
    init(code: SourceCode, name: String, type: String, graphqlPath: CurrentStage.Path?) {
        self.init(code: code, name: name, type: type) { CurrentStage.pathKey ~> graphqlPath }
    }
    
}
