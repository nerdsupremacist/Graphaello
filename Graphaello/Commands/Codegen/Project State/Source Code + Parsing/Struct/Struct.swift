//
//  Struct.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/1/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct Struct<CurrentStage: StageProtocol> {
    let code: SourceCode
    let name: String
    let properties: [Property<CurrentStage>]
}

extension Struct {

    func map<Stage: StageProtocol>(_ transform: (CurrentStage.Information) throws -> Stage.Information) rethrows -> Struct<Stage> {
        return try map { try $0.map { try transform($0) } }
    }

    func map<Stage: StageProtocol>(_ transform: (Property<CurrentStage>) throws -> Property<Stage>) rethrows -> Struct<Stage> {
        return Struct<Stage>(code: code, name: name, properties: try properties.map { try transform($0) })
    }

}

extension Struct where CurrentStage: GraphQLStage {

    var hasGraphQLValues: Bool {
        return properties.contains { $0.graphqlPath != nil }
    }

}
