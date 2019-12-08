//
//  PathFromBaseMemberAccessParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

struct PathFromBaseMemberAccessParser: SubParser {

    func parse(from access: BaseMemberAccess) throws -> Stage.Parsed.Path {
        if (access.accessedField.capitalized == access.accessedField) {
            return Stage.Parsed.Path(apiName: access.base,
                                     target: .object(access.accessedField),
                                     components: [])
        } else {
            return Stage.Parsed.Path(apiName: access.base,
                                     target: .query,
                                     components: [.property(access.accessedField)])
        }
    }
}
