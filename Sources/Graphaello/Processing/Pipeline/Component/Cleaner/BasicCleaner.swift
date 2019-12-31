//
//  BasicCleaner.swift
//  
//
//  Created by Mathias Quintero on 12/28/19.
//

import Foundation

struct BasicCleaner: Cleaner {
    let argumentCleaner: AnyArgumentCleaner<Struct<Stage.Resolved>>

    func clean(resolved: Struct<Stage.Resolved>) throws -> Struct<Stage.Cleaned> {
        return try argumentCleaner
            .clean(resolved: resolved)
            .with(properties: [])
    }
}

extension BasicCleaner {

    init(argumentCleaner: () -> AnyArgumentCleaner<Struct<Stage.Resolved>>) {
        self.init(argumentCleaner: argumentCleaner())
    }

}
