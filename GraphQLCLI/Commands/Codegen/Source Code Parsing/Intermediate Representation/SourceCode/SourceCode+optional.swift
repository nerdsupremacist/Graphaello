//
//  SourceCode+optional.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension SourceCode {

    func optional<T>(decode: (SourceCode) throws -> T) rethrows -> T? {
        do {
            return try decode(self)
        } catch ParseError.missingKey {
            return nil
        }
    }

}
