//
//  Property.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct Property<CurrentStage: StageProtocol> {
    let code: SourceCode
    let name: String
    let type: String
    let info: CurrentStage.Information
}

extension Property {

    func map<Stage: StageProtocol>(_ transform: (CurrentStage.Information) throws -> Stage.Information) rethrows -> Property<Stage> {
        return Property<Stage>(code: code, name: name, type: type, info: try transform(info))
    }

}
