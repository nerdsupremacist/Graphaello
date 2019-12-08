//
//  SubParser.swift
//  Graphaello
//
//  Created by Mathias Quintero on 12/8/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

protocol SubParser {
    associatedtype Input
    associatedtype Output
    
    func parse(from: Input) throws -> Output
}
