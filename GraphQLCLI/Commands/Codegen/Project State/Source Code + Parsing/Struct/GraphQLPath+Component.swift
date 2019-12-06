//
//  GraphQLPath+Component.swift
//  GraphQLCLI
//
//  Created by Mathias Quintero on 12/4/19.
//  Copyright © 2019 Mathias Quintero. All rights reserved.
//

import Foundation

extension GraphQLPath {

    enum Component: Equatable {
        case property(String)
        case fragment
        case call(String, [String : Argument])
    }

}
