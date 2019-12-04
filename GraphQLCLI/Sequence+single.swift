//
//  Sequence+single.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/3/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension Collection {

    func single() -> Element? {
        guard count == 1 else { return nil }
        return first
    }

}
