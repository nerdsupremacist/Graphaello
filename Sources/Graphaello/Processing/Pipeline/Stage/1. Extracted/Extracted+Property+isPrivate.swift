//
//  File.swift
//  
//
//  Created by Mathias Quintero on 1/15/20.
//

import Foundation

extension Property where CurrentStage == Stage.Extracted {

    func isPrivate() throws -> Bool {
        let accesibility = try code.optional { try $0.accesibility() } ?? .internal
        return [.private, .fileprivate].contains(accesibility)
    }

}
