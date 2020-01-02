//
//  Cleaner.swift
//  
//
//  Created by Mathias Quintero on 1/1/19.
//

import Foundation

protocol Cleaner {
    func clean(resolved: [Struct<Stage.Resolved>]) throws -> [Struct<Stage.Cleaned>]
}
